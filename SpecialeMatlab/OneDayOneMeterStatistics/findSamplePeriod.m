function [ Ts, missing ] = findSamplePeriod( mdata )
%FINDSAMPLEPERIOD Summary of this function goes here
%   Detailed explanation goes here

    dt = mdata{2:end,1} - mdata{1:end-1,1};
    
    Ts = median(dt);
    missing = find(dt>(Ts*1.5));
    numberofmis = round(dt(missing)/Ts)-1;
    missing = [missing numberofmis];
    
end

