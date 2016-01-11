function [ activitymap ] = findactivity( mdata, number )
%FINDACTIVITY Summary of this function goes here
%   Detailed explanation goes here

    activitymap = zeros(size(mdata,1),1);
    mdatapadded = [mdata{:,2}; ones(number,1)*mdata{end,2}]; 
    
    for i = 1:size(mdata,1)
        activitymap(i) = std(mdatapadded(i:i+number))>5;
    end
    
end

