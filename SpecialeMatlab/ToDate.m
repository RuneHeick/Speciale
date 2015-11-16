function [ time ] = ToDate( date_string )
%TODATE Summary of this function goes here
%   Detailed explanation goes here
        str = strtok(date_string,'+');
        try
            time = datenum(datetime(str,'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSSS'));
        catch
            time = datenum(datetime(str,'InputFormat','yyyy-MM-dd HH:mm:ss'));
        end
end

