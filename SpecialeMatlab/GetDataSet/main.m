
conn = database('dbservice','runeheick','cykeljernhest','Vendor','PostgreSQL','Server','dbservice.eng.au.dk')
setdbprefs('DataReturnFormat','table');

house = 5
from = datetime(2015,6,1); % start
EndTime = datetime(2015,7,1);

numdaysvec = datevec(datenum(EndTime)-datenum(from));
info = GetHouseInfo(conn, house)

Data = cell(size(info,1),2);
Data(:,1) = num2cell(info{:,3});

for day = 0:numdaysvec(3)

    startGet = from +days(day);
    endGet = from +days(day+1);
    
    Data = GetMeasurementData(conn, house, startGet, endGet, Data);
end


close(conn)

%% 
figure(2)
mainMeterNr = 1 % 2 10
subMeterNr = 7 % 2 10

subplot(2,1,1)
mData = Data{mainMeterNr,2};
plot(mData{:,1},mData{:,2})

subplot(2,1,2)
sData = Data{subMeterNr,2};
plot(sData{:,1},sData{:,2})

[ vqSub error] = CleanDataSet(sData);
[vqMain error2] = CleanDataSet(mData);


%% plot
figure
subplot(2,1,1)
plot(vqMain);
hold on 
scatter(error2, zeros(size(error2)), 'r');
subplot(2,1,2)
plot(vqSub);
hold on 
scatter(error, zeros(size(error)), 'r');

%% 
size1 = error(2:end) - error(1:end-1);
size2 = error2(2:end) - error2(1:end-1);

[~, max1 ] = max(size1);
[~, max2 ] = max(size2);

data = []; 
load('DataSnips');

data{size(data,2)+1} =  vqSub(error(max1):error(max1+1));

data{size(data,2)+1} =  vqMain(error2(max2):error2(max2+1));

save('DataSnips', 'data');


