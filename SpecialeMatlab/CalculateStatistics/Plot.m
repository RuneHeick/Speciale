close all; 

houseData = zeros(25,11);

from = datetime(2015,4,1); % start
EndTime = datetime(2015,11,1);
interval = 12; % i timer 

gapHis       = zeros(20000,1); 
gapPriorPost = cell(20000,1); 

for house = 2:26
    
    disp(strcat('House Start',num2str(house)));
    
    load(strcat('Quality',num2str(house)),'QData','info');
    figure
    for mcount = 1: size(QData,2)
        Q = [];
        HouseQIndex = QData{mcount}; 
        for i = 1: size(HouseQIndex,2)
                        
            startTime = (datenum(datetime(2015,3+mcount,1,(i-1)*interval,0,0))-datenum(datetime(1970,1,1)))*24*60*60 - (60*60*2);
            EndTime = (datenum(datetime(2015,3+mcount,1,i*interval,0,0))-datenum(datetime(1970,1,1)))*24*60*60 - (60*60*2);
            ActiveMeters = ( EndTime >= info{:,5} ) .* (info{:,6} >= startTime);
            
            %dummy 
            %ActiveMeters  = [ 0 0 1 1 1 zeros(1,size(ActiveMeters,1)-5) ]';
            
            
            Meterdata = []; 
            for z = 1:size(HouseQIndex{i},1)
                Mdata = HouseQIndex{i}{z,1};
                GapData = HouseQIndex{i}{z,2};
                
                if(isempty(Mdata))
                    Meterdata(z,:) = [0 0 0];
                else
                    Meterdata(z,:) = Mdata;
                end
                
                if(size(GapData,1)>2)
                    for s = 2:size(GapData,1)-1
                        
                        gapsize = ceil(GapData(s,1));
                        
                        prior = GapData(s,2) - (GapData(s-1,2)+floor(GapData(s-1,1)));
                        post = GapData(s+1,2) - (GapData(s,2)+floor(GapData(s,1)));
                        
                        priorpostset = gapPriorPost{gapsize};
                        priorpostset = [ priorpostset ; [ prior post ] ]; 
                        
                        gapPriorPost{gapsize} = priorpostset;
                    end
                end
                
                for g = 1:length(GapData)
                    gapHis(ceil(GapData(g))) = gapHis(ceil(GapData(g)))+1;
                end
                
            end
            
            Mquality = Meterdata(:,2)./Meterdata(:,1);
            Mquality(find(isnan(Mquality))) = 0; 
            
            Hquality = sum((Mquality.*ActiveMeters))/sum(ActiveMeters);
            
            Mactivity = Meterdata(:,3);
            Mactivity(find(isnan(Mactivity))) = 0; 
            
            MetersWithActivity = Mactivity>100;
            Hactivity = sum((MetersWithActivity.*ActiveMeters))/sum(ActiveMeters);
            
            if(sum(ActiveMeters)>0)
                index = floor(Hquality*10)+1; 
                if(index>11)
                    index = 11; 
                end
                houseData(house-1,index) = houseData(house-1,index)+1;
            end
            
            Q = [Q ; [Hquality, Hactivity , sum(ActiveMeters) ]];
            
        end
              
        
        informationDensity = Q(:,3)./20;
        Valid =  Q(:,1);
        Active =  Q(:,2);
        
        
        subplot(size(QData,2),1,mcount)
        hold on
        c = [1-informationDensity, informationDensity , zeros(size(informationDensity,1),1)];
        scatter((1/24*interval):(1/24*interval):(length(Q)*interval/24),ones(length(Q),1),5,c,'filled')

        c = [1-Valid, Valid , zeros(size(Valid,1),1)];
        scatter((1/24*interval):(1/24*interval):length(Q)*interval/24,ones(length(Q),1)*2,5,c,'filled')
        
        c = [1-Active, Active , zeros(size(Active,1),1)];
        scatter((1/24*interval):(1/24*interval):length(Q)*interval/24,ones(length(Q),1)*3,5,c,'filled')
        
        title( month(from-hours(29),'name'))
        ylim([0 4]);
        xlim([0 31]);
        set(gca,'YTick', [1 2 3]);
        set(gca,'YTickLabel',{'Density'; 'Valid'; 'Active'} );
        
        
        hold off
        
       
    end
    
     disp('House done');
end

His = [(1:length(gapHis))'  gapHis];
His = His(find(His(:,2)~=0),:);
His(:,3) = His(:,1).*His(:,2);

HisTotal = sum(His(:,3));
His(:,4) = cumsum(His(:,3))./HisTotal;


fig = figure('units','normalized','position',[.1 .1 .35 .2])

fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 2];
fig.PaperPositionMode = 'manual';

plot([0 ; His(:,4)]);
xlim([0 400]);
xlabel('Gap size correction capability')
ylabel('Recovered samples')
% Convert y-axis values to percentage values by multiplication
     a=[cellstr(num2str(get(gca,'ytick')'*100))]; 
% Create a vector of '%' signs
     pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
     new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
     set(gca,'yticklabel',new_yticks);
print(fig,'-dpng','CorrectionCapability')

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


