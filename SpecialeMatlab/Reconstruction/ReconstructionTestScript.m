close all; 
clear all; 
load('DataSnips');

Reconstructors = @(x,gapStart,gapSize, known)[
            PGGapFixer(x,gapStart,gapSize, known)'
            WienerGapFixer(x,gapStart,gapSize, known)'
            EnvGapFixer(x,gapStart,gapSize, known)'
            EMDGapFixer(x,gapStart,gapSize, known)'
            SSAGapFixer(x,gapStart,gapSize, known)'
        ]; 

CollectedResult = {}; 
index1 = 1; 
for gapSize = 1:5:100
    
    gapSizeResult = {}; 
    
    index2 = 1; 
    for known = 3:5:100
        
        index3 = 1; 
        knownResult = {}; 
        
        for gapIndex = 1:size(data,2)
   
          setId = gapIndex;  
          x = (data{setId}(1:end))';
          n = (1:length(x))'; 
          
          rest = length(x) - 2*known;
          if(rest > gapSize)
            gapStart = 135;
            disp(['chekking Gap: ' num2str(gapSize) ' Known:' num2str(known) ' Senario: ' num2str(gapIndex)]);
            
            reconstructed = Reconstructors(x,gapStart,gapSize, known);
            
            orginal = x(gapStart:gapStart+gapSize-1)';
            
            STDVAR = std(orginal); 
            
            ffttransformorginal = fft(x(gapStart-known:gapStart+gapSize-1+known))';
            Porg = ffttransformorginal .* conj(ffttransformorginal); 
            
            Result{1} =  STDVAR;
%             figure(4)
%             subplot(size(reconstructed,1)+1,1,1)
%             plot(n,x)
%             hold on
%             plot(n(gapStart:gapStart+gapSize-1),x(gapStart:gapStart+gapSize-1));
%             hold off
            
            for i = 1: size(reconstructed,1)
                    
                mse = immse(reconstructed(i,gapStart:gapStart+gapSize-1),orginal);
                
                ffttransform = fft(reconstructed(i,gapStart-known:gapStart+gapSize-1+known));
                Prec = ffttransform .* conj(ffttransform); 
                msePower = immse(Porg,Prec );
                
                Result{1+i} = [mse msePower];
                
                
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