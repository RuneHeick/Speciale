function [ input ] = FillGapSingle( input , method )

    if( strcmp(method,'Linear'))
        okaySamples = input ~= -1; 
        index = find(okaySamples);
        if(~isempty(index))
            input = interp1(index,input(index),1:length(input));
        end
    elseif(strcmp(method,'Env'))
        okaySamples = input ~= -1; 
        index = find(okaySamples);
        if(length(index) > 2)
            input = EnvGapFiller(input); 
        end
    elseif( strcmp(method,'PG'))
        validRange = 50; 
        inputRange = (validRange)/2; 
        
        fracMean = mean(input(input~= -1  & input ~= inf & input ~= -inf)); 
        formatinput = input;
        formatinput(formatinput~= -1) = formatinput(formatinput~= -1) - fracMean;
        
        
        batchCount = (length(input)-2*inputRange)/validRange; 
        disp(['PG on ' num2str(batchCount) ' Batches']);
        for p = 1:batchCount
            startIndex = (p-1)*validRange + 1;
            endIndex = startIndex+2*inputRange+validRange-1;
            
            fracData = formatinput(startIndex:endIndex)'; 
            validData = fracData ~= -1;
            
            if(sum(validData == 0) == 0)
               continue; 
            end
            
            D = diag(validData);
            
            y = D*fracData; 
            bestfit = 0; 
            isStarted = 0; 
            bestfitpoint = 0; 
            besthat = []; 

            for M = 1:length(y)/2
                gamma = [ones(M,1) ; zeros(size(fracData,1)-2*M,1) ; ones(M,1)];
                GAMMA = diag(gamma);
                
                F = dftmtx(size(fracData,1));
                B = inv(F)*GAMMA*F;
                I = eye(size(fracData,1));
                
                
                x_hat = y;
                x_old = y;
                
                delta = 0.00000001;
                
                for i = 1:100
                    
                    x_hat = y + (I-D)*B*x_hat;
                    
%                     if i>20 && (sum(abs(x_old-x_hat))/size(x_hat,1) < delta)
%                         besthat = x_hat;
%                         break;
%                     end
                    
                    x_old = x_hat;
                    
                end
                
                sigFFT = fft(real(x_hat));
                
                E_t = sum(abs(sigFFT(1:end/2)).^2);
                E_h = sum(abs(sigFFT(ceil(end/2-end/5):end/2)).^2);
                
                
                g(M) = log10(E_h/E_t);
                
                if(M>2 && g(M-1) < bestfit )
                    bestfit = g(M-1);
                    besthat = x_hat;
                end
            end
            
            try
            filledvalues = (real(besthat)+fracMean);
            needfill = find(input(startIndex+inputRange:endIndex-inputRange)== -1);
            
            sliceindex = needfill+inputRange; 
            
            input(startIndex+inputRange+needfill-1) = filledvalues(sliceindex);
            catch
               disp('Error'); 
            end
            
        end
    end


end

