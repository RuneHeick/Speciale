close all; 
clear all; 
load('DataSnips');

gapSizes = [1:20 25:5:50];
knowns = [3 20 80];


MaxGap = 100; 
GapStepSize = 5;

Reconstructors = @(x,gapStart,gapSize, known)[
            PGGapFixer(x,gapStart,gapSize, known)'
            WienerGapFixer(x,gapStart,gapSize, known)'
            EnvGapFixer(x,gapStart,gapSize, known)'
            EMDGapFixer(x,gapStart,gapSize, known)'
            SSAGapFixer(x,gapStart,gapSize, known)'
        ]; 

CollectedResult = cell(length(gapSizes),1); 
index1 = 1; 
for gapSize = gapSizes
    
    gapSizeResult = cell(length(knowns),1); 
    
    index2 = 1; 
    for known = knowns
        
        index3 = 1; 
        
        senarios = 1:size(data,2);
        
        knownResult = cell(length(senarios),1); 
        for gapIndex = senarios
   
          setId = gapIndex;  
          x = (data{setId}(1:end))';
          n = (1:length(x))'; 
          
          rest = length(x) - 2*known;
          if(rest > gapSize)
            gapStart = 135;
            disp(['chekking Gap: ' num2str(gapSize) ' Known:' num2str(known) ' Senario: ' num2str(gapIndex)]);
            
            reconstructed = Reconstructors(x,gapStart,gapSize, known);
            
            orginal = x';
            
            ffttransformorginal = fft(x');
            Porg = ffttransformorginal .* conj(ffttransformorginal); 

%             figure(4)
%             subplot(size(reconstructed,1)+1,1,1)
%             plot(n,x)
%             hold on
%             plot(n(gapStart:gapStart+gapSize-1),x(gapStart:gapStart+gapSize-1));
%             hold off
            
            mins = [];
            maxes = []; 
            [mins(2,:), mins(1,:)] = findpeaks(orginal*-1); 
             mins(2,:) = mins(2,:)*-1; 
            [maxes(2,:), maxes(1,:)] = findpeaks(orginal); 

            maxenv = interp1(maxes(1,:),maxes(2,:),1:size(orginal,2));
            maxenv(find(isnan(maxenv))) = 0; 
            minenv = interp1(mins(1,:), mins(2,:), 1:size(orginal,2));
            minenv(find(isnan(minenv))) = 0; 
            meanLine = minenv + (maxenv - minenv)/2;
            
%             figure(5)
%             plot(orginal)
%             hold on 
%             plot(meanLine)
%             hold off
            
            OrginalgitterPower = (orginal-meanLine).^2;

            Result = zeros(size(reconstructed,1),3);
            for i = 1: size(reconstructed,1)

                mse = immse(reconstructed(i,gapStart:gapStart+gapSize-1),orginal(gapStart:gapStart+gapSize-1));
                
                ffttransform = fft(reconstructed(i,:));
                Prec = ffttransform .* conj(ffttransform); 
                msePower = immse(Porg,Prec );
                
                gitterPower = (reconstructed(i,:)-meanLine).^2;
                mseGitterPower = immse(gitterPower(gapStart:gapStart+gapSize-1), OrginalgitterPower(gapStart:gapStart+gapSize-1));
                
                
                Result(i,:) = [mse msePower mseGitterPower];
                
                
%                 subplot(size(reconstructed,1)+1,1,i+1)
%                 plot(n,reconstructed(i,:))
%                 hold on
%                 plot(n(gapStart:gapStart+gapSize-1),reconstructed(i,gapStart:gapStart+gapSize-1));
%                 hold off
            end
            
            knownResult{index3} = Result;
            
            index3 = index3+1;
          end
        end
        gapSizeResult{index2,1} = known;
        gapSizeResult{index2,2} = knownResult;
        index2 = index2+1 ;
    end
    CollectedResult{index1,1} = gapSize;
    CollectedResult{index1,2} = gapSizeResult;
    index1 = index1+1;
end

save('ColRes','CollectedResult');
