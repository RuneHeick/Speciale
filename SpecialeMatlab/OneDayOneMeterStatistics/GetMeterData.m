function [ mdata ] = GetMeterData( dataSet, Meterid)
%FINDQU Summary of this function goes here
%   Detailed explanation goes here
        

    if(isempty(dataSet))
        mdata = [];
        return;
    end
    
    mdata = dataSet(find(dataSet{:,3} == Meterid),:); 
    

end

