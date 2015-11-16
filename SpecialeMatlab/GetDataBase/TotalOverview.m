clear all; 

conn = database('dbservice','runeheick','cykeljernhest','Vendor','PostgreSQL','Server','dbservice.eng.au.dk')
setdbprefs('DataReturnFormat','table');

houseData = zeros(24,11);
hold on; 
for house = 2:25
    info = GetHouseInfo(conn, house);
    load(strcat('Quality',num2str(house)))
    
    
    for m = 5: size(QData,2)
        monthData = QData{m}; 
        
        for t = 1: size(monthData,2)
           good = monthData(1,t)/size(info,1) ;
           index = floor(good*10)+1; 
           
           houseData(house-1,index) = houseData(house-1,index)+1; 
            
        end
        
    end
    
        
end

figure(1)
sumpcr = sum(houseData,1)
explode = [1 1 1 1 1 1 1 1 1 1 1]
labels = {'0-9%','10-19%','20-29%','30-39%','40-49%','50-59%','60-69%','70-79%','80-89%','90-99%', '100%' };
pie(sumpcr,explode,labels)
title('Hours Quality');

housepcr = [sum(houseData(:,1:4),2) sum(houseData(:,5:8),2) sum(houseData(:,9:11),2)]

figure(2)
bar(housepcr,'stacked');
legend('0-39%','40-79%', '80-100%');
title('House Quality Hours');

