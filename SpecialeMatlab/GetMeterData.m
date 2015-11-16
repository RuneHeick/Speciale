function [ time ] = GetMeterData( target, Data )
%GETMETERDATA Summary of this function goes here
%   Detailed explanation goes here

for n = 1:height(Data)
    
    if (Data{n,4} == target)
        date = strrep(table2array(Data(n,2)),'''','');
        str = strtok(date,'+');
        time(n,2) = double(Data{n,3});
        try
            time(n,1) = datenum(datetime(str,'InputFormat','yyyy-MM-dd HH:mm:ss.SS'));
        catch
            time(n,1) = datenum(datetime(str,'InputFormat','yyyy-MM-dd HH:mm:ss'));
        end

        if(n>1)
            time(n,3) = time(n,1) - time(n-1,1);
        end
    end
end

end

