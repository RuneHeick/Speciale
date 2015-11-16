function [ activity ] = ActivityAnalyses( data )
%ACTIVITYANALYSES Summary of this function goes here
%   Detailed explanation goes here
    
    Y = std(data(:,2));
    activity  = Y > 10;
    
end

