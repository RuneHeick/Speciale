function [  ] = DownloadDataSetFunc( conn, ports )
%DOWNLOADDATASETFUNC Summary of this function goes here
%   Detailed explanation goes here

path = 'downloadedData';

fromStart = datetime(2015,6,1,0,0,0); % start
EndTime = datetime(2015,8,31,0,0,0);

mkdir(path);
for port = ports
    
    disp(['Downloading port ' num2str(port)]);
    
    savedir = [path '\' num2str(port)];
    mkdir(savedir);
    
    
    from = fromStart;
    to = from;
    
    tic;
    while(to<EndTime)
        to = from + day(1);
        
        try
            data = GetMeasurementData(conn, port, from, to);
        catch
            conn = database('dbservice','runeheick','cykeljernhest','Vendor','PostgreSQL','Server','dbservice.eng.au.dk')
            setdbprefs('DataReturnFormat','table');
            data = GetMeasurementData(conn, port, from, to);
        end
        
        fromstr = datestr(from,'yyyy-mm-dd');
        
        save([savedir '\' fromstr], 'data');
        
        from = to;
    end
    toc;
end

end

