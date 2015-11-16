
conn = database('dbservice','runeheick','cykeljernhest','Vendor','PostgreSQL','Server','dbservice.eng.au.dk')
setdbprefs('DataReturnFormat','table');

for house = 2:26

    from = datetime(2015,4,1); % start
    EndTime = datetime(2015,11,1);
    interval = 1; % i timer 


    to  = from+hours(interval);
    mCount = 1; 
    numdaysvec = datevec(datenum(EndTime)-datenum(from));
    nummonths = numdaysvec(1) * 12 + numdaysvec(2) - 1;

    QData = cell(1, nummonths); 
    house
    
    info = GetHouseInfo(conn, house)
    start = nan(size(info,1),1);
    stop = nan(size(info,1),1);
    startStopTable = table(start,stop);
    
    info = [info startStopTable];
    
    while(to<EndTime)

    steps = ((eomdate(from)-datenum(from))+1)*24; 
    Quality = cell(size(info,1), 1);
    HouseQIndex = zeros(2, steps);

    for s = 1:steps
        data = GetMeasurementData(conn, house, from, to);

        [Quality(:),info] = FindQuality(data, info);

        validData = cellfun(@(x) (x(3)*x(9))/(60*60)>0.8, Quality);
        HouseQIndex(:,s) = [sum(validData) , sum(cellfun(@(x) x(10), Quality(validData)))];

        from = to; 
        to  = from+hours(interval);
    end


        QData{mCount} = HouseQIndex;

        disp(['House: ' num2str(house) ' M: ' num2str(mCount)]);
        
%         subplot(nummonths,1,mCount)
%         alpha = (HouseQIndex(1,:) ./ (size(info,1)/2));
%         c = [1-alpha', alpha' , zeros(size(alpha,2),1)];
%         scatter(1/24:1/24:length(HouseQIndex)/24,ones(length(HouseQIndex),1),5,c)
%         hold on
% 
%         alpha =  (HouseQIndex(2,:) ./ (size(info,1)/2));
%         c = [1-alpha', alpha' , zeros(size(alpha,2),1)];
%         scatter(1/24:1/24:(length(HouseQIndex)/24),ones(length(HouseQIndex),1)*-1,5,c)
%         title( month(from-hours(29),'name'))
%         hold off
% 
%         ylim([-2 2]);
%         xlim([0 31]);
%         set(gca,'YTick',[-1 0 1] ); 
%         set(gca,'YTickLabel',{'Active'; ''; 'Valid'} );
% 
%         pause(0.1);

          mCount = mCount+1; 
        
        
    end
    save(strcat('Quality',num2str(house)),'QData','info');
end
close(conn)
