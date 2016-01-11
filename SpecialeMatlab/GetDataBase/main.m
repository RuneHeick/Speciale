
conn = database('dbservice','runeheick','cykeljernhest','Vendor','PostgreSQL','Server','dbservice.eng.au.dk')
setdbprefs('DataReturnFormat','table');


house = 4; 

from = datetime(2015,6,15,12,0,0); % start
EndTime = datetime(2015,6,16,12,0,0);
interval = 1/60; % i timer 


to  = from+hours(interval);
mCount = 1; 
numdaysvec = datevec(datenum(EndTime)-datenum(from));
nummonths = numdaysvec(1) * 12 + numdaysvec(2) - 1;

QData = cell(1, min(1,nummonths)); 

try
        info = GetHouseInfo(conn, house)
catch
        conn = database('dbservice','runeheick','cykeljernhest','Vendor','PostgreSQL','Server','dbservice.eng.au.dk')
        setdbprefs('DataReturnFormat','table');
        info = GetHouseInfo(conn, house);
end

start = nan(size(info,1),1);
stop = nan(size(info,1),1);
startStopTable = table(start,stop);

info = [info startStopTable];

while(to<EndTime)

steps = round((((datenum(to)-datenum(from))+1)*24)/interval); 
HouseQIndex = cell(1, steps);

for s = 1:steps
    try
        data = GetMeasurementData(conn, house, from, to);
    catch
        conn = database('dbservice','runeheick','cykeljernhest','Vendor','PostgreSQL','Server','dbservice.eng.au.dk')
        setdbprefs('DataReturnFormat','table');
        data = GetMeasurementData(conn, house, from, to);
    end

    [res, info] = FindQuality(data, info, from, to );
    HouseQIndex(1,s) = {res};


    from = to; 
    to  = from+hours(interval);
    
    disp('Got 2 min more');
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
    
save(strcat('Quality5Min',num2str(house)),'QData','info');
close(conn)
