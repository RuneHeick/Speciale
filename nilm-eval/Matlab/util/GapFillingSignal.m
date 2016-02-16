function [ inputsignal ] = GapFillingSignal( inputsignal , method )
%GAPFILLINGSIGNALL Summary of this function goes here
%   Detailed explanation goes here
    
    if(isstruct(inputsignal))
        fields = fieldnames(inputsignal);      
        for i = 1:numel(fields)
            data = inputsignal.(fields{i}); 
            inputsignal.(fields{i}) = FillGapSingle(data,method); 
        end
    else
        inputsignal = FillGapSingle(inputsignal,method);
    end
    
end

