

houseData = zeros(25,11);


for house = 2:26
    
    load(strcat('Quality',num2str(house)),'QData','info');
    figure
    for mcount = 1: size(QData,2)
        
        HouseQIndex = QData{mcount}; 
        for i = 1: size(HouseQIndex,2)
            
            from = datetime(2015,3+mcount,1,i-1,0,0);
            startTime = (datenum(datetime(2015,3+mcount,1,i-1,0,0))-datenum(datetime(1970,1,1)))*24*60*60 - (60*60*2);
            EndTime = (datenum(datetime(2015,3+mcount,1,i,0,0))-datenum(datetime(1970,1,1)))*24*60*60 - (60*60*2);
            ActiveMeters = (((info{:,5} <= startTime) .* (info{:,6} >= EndTime)) + ((info{:,5} >= startTime) .* (info{:,6} <= EndTime)))>0;
            
            HouseQIndex(3,i) = sum(ActiveMeters);
            
            if(HouseQIndex(3,i)>0)
                good = HouseQIndex(1,i)/HouseQIndex(3,i) ;
                index = floor(good*10)+1; 
                if(index<=11)
                    houseData(house-1,index) = houseData(house-1,index)+1;
                end
            end
        end
              
        
        informationDensity = HouseQIndex(3,:)./20;
        Valid =  (HouseQIndex(1,:) ./ HouseQIndex(3,:));
        Active =  (HouseQIndex(2,:) ./ HouseQIndex(3,:));
        
        
        subplot(size(QData,2),1,mcount)
        hold on
        c = [1-informationDensity', informationDensity' , zeros(size(informationDensity,2),1)];
        scatter(1/24:1/24:length(HouseQIndex)/24,ones(length(HouseQIndex),1),2,c,'s')

        c = [1-Valid', Valid' , zeros(size(Valid,2),1)];
        scatter(1/24:1/24:length(HouseQIndex)/24,ones(length(HouseQIndex),1)*2,2,c,'s')
        
        c = [1-Active', Active' , zeros(size(Active,2),1)];
        scatter(1/24:1/24:length(HouseQIndex)/24,ones(length(HouseQIndex),1)*3,3,c,'s')
        
        title( month(from-hours(29),'name'))
        ylim([0 4]);
        xlim([0 31]);
        set(gca,'YTick',[1 2 3] );
        set(gca,'YTickLabel',{'Density'; 'Valid'; 'Active'} );
        
        
        hold off
        
        
    end
    
   
    
end

figure
sumpcr = sum(houseData,1)
explode = [1 1 1 1 1 1 1 1 1 1 1]
labels = {'0-9%','10-19%','20-29%','30-39%','40-49%','50-59%','60-69%','70-79%','80-89%','90-99%', '100%' };
pie(sumpcr,explode,labels)
title('Hours Quality');

housepcr = [sum(houseData(:,1:4),2) sum(houseData(:,5:8),2) sum(houseData(:,9:11),2)]

figure
bar(housepcr,'stacked');
legend('0-39%','40-79%', '80-100%');
title('House Quality Hours');


