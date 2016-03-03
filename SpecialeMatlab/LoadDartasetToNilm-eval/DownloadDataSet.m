
conn = database('dbservice','runeheick','cykeljernhest','Vendor','PostgreSQL','Server','dbservice.eng.au.dk')
setdbprefs('DataReturnFormat','table');

path = 'downloadedData'; 

%{ {1,[5],[6 9 11 13]}, {2,[85],[87 89 91 93]} , {3,[165],[167 169 171 173]} }
ports = [[15],[19 21 23],[85],[87 89 91 93], [165],[167 169 171 173] ];

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

close(conn)
