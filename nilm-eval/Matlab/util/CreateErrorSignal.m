function [ inputsignal ] = CreateErrorSignal( inputsignal, errorrate )

    if errorrate == 0
       return; 
    end

    if(isstruct(inputsignal))
        fields = fieldnames(inputsignal);
        
        datasize = size(inputsignal.(fields{1}));
        mask = rand(datasize) <= errorrate;
       
        for i = 1:numel(fields)
            data = inputsignal.(fields{i}); 
            data(find(mask)) = -1; 
            inputsignal.(fields{i}) = data; 
        end
    else
        datasize = size(inputsignal);
        mask = rand(datasize) <= errorrate;
        inputsignal(find(mask)) = -1; 
    end

end

