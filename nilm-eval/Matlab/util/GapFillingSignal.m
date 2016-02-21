function [ inputsignal ] = GapFillingSignal( inputsignal , method )
%GAPFILLINGSIGNALL Summary of this function goes here
%   Detailed explanation goes here
    
    if(isstruct(inputsignal))
        fields = fieldnames(inputsignal);     
        datasize = size(inputsignal.(fields{1}));
        
        for i = 1:numel(fields)
            data = inputsignal.(fields{i}); 
            if(size(data) == datasize)
                inputsignal.(fields{i}) = FillGapSingle(data,method); 
            end
        end
    else
        inputsignal = FillGapSingle(inputsignal,method);
    end
    
end

