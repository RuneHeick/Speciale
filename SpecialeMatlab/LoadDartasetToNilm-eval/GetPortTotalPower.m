function [ power, time ] = GetPortTotalPower( port )
%GETPORTTOTALPOWER Summary of this function goes here
%   Detailed explanation goes here

    path = 'downloadedDataClean';
    power = 0; 
    time = 0; 
    listing = dir([path '\' num2str(port)]);
    for index = 3:length(listing)
        file = listing(index).name;
        values = load([path '\' num2str(port) '\' file]);
        
        adata = values.data; 
        adata(adata == -1) = 0; 
        
        time = time + length(adata);
        power = power+ sum(adata);  
    end
end

