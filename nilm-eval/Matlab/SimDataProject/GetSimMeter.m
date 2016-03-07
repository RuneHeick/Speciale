function [ simdata ] = GetSimMeter( dataPath, ports, dayfile )
%GETSIMMETER Summary of this function goes here
%   Detailed explanation goes here

    simdata = zeros(24*60*60,1); 
    for port = ports
            values = load([dataPath '\' num2str(port) '\' dayfile]);
            data = values.data;
            data(data == -1) = 0; 
            simdata = simdata + data;
    end
            
end

