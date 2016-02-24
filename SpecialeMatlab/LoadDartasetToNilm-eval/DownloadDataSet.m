
conn = database('dbservice','runeheick','cykeljernhest','Vendor','PostgreSQL','Server','dbservice.eng.au.dk')
setdbprefs('DataReturnFormat','table');

path = 'downloadedData'; 

ports = [85;87;89;91;93;1206;1207;1208;1209;1210;1211;1212;1213;1214;1215;1216;1328;1329;1330;1331;1332]';

fromStart = datetime(2015,9,1,0,0,0); % start
EndTime = datetime(2015,10,31,0,0,0);

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

close(conn)
