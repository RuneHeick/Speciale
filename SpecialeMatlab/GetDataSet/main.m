
conn = database('dbservice','runeheick','cykeljernhest','Vendor','PostgreSQL','Server','dbservice.eng.au.dk')
setdbprefs('DataReturnFormat','table');

house = 24
from = datetime(2015,5,1); % start
EndTime = datetime(2015,6,1);

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
mainMeterNr = 2 % 2 10
subMeterNr = 10 % 2 10

subplot(2,1,1)
mData = Data{mainMeterNr,2};
plot(mData{:,1},mData{:,2})

subplot(2,1,2)
sData = Data{subMeterNr,2};
plot(sData{:,1},sData{:,2})

%% interpolation Linear

%Main meter data
[x, i] = unique(mData{:,1});
y = mData{i,2};
n = min(x):30:max(x);
vqMain = interp1(x,y,n);

%supmeter
[x, i] = unique(sData{:,1});
y = sData{i,2};
vqSub = interp1(x,y,n);

% plot 
figure
subplot(2,1,1)
plot(n,vqMain);
subplot(2,1,2)
plot(n,vqSub);

%% Find error area 

Sdelay = sData{2:end,1}-sData{1:end-1,1}; 
maxAllowedDelay = mean(Sdelay)*1.2; 

ErrorI = find(Sdelay>maxAllowedDelay);
ErrorTimes = [sData{ErrorI,1} sData{ErrorI+1,1}, Sdelay(ErrorI)];


%% Remove errors 
index = 1;
for i = 1: size(n,2)

   if( n(i) > ErrorTimes(index,1) && n(i) < ErrorTimes(index,2))
       vqSub(i) = nan; 
   end
   
   if(n(i) > ErrorTimes(index,2))
      index = index +1 ;
      if index > size(ErrorTimes,1)
         break; 
      end
   end
    
end

%% reconstruction





