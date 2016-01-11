
conn = database('dbservice','runeheick','cykeljernhest','Vendor','PostgreSQL','Server','dbservice.eng.au.dk')
setdbprefs('DataReturnFormat','table');


house = 10; 
day = 16;
month = 8;

from = datetime(2015,month,day,12,0,0); % start
to = datetime(2015,month,day+1,0,0,0);

try
        info = GetHouseInfo(conn, house)
catch
        conn = database('dbservice','runeheick','cykeljernhest','Vendor','PostgreSQL','Server','dbservice.eng.au.dk')
        setdbprefs('DataReturnFormat','table');
        info = GetHouseInfo(conn, house);
end


try
    data = GetMeasurementData(conn, house, from, to);
catch
    conn = database('dbservice','runeheick','cykeljernhest','Vendor','PostgreSQL','Server','dbservice.eng.au.dk')
    setdbprefs('DataReturnFormat','table');
    data = GetMeasurementData(conn, house, from, to);
end

%save(strcat('Quality5Min',num2str(house)),'QData','info');
close(conn)

%%
ActiveMeters = [85 86 88 91 92]';% intersect(info{:,3},data{:,3}); 
meters = size(ActiveMeters,1); 

%%
close all 


figure 
ax1 = axes('Position',[0 0 1 1],'Visible','off');
ylim manual
ax2 = axes('Position',[.2 0.1 .75 0.8]);

descriptionStart = 0.15; 
descriptiondelta = 0.879/meters; 
desxpos = .1;

title(['House ' num2str(house)]);

poltId = 0; 
for selectedMeter = ActiveMeters'
    mdata = GetMeterData(data,selectedMeter);

    if(isempty(mdata))
        continue; 
    end 
    
    [Ts, missing] = findSamplePeriod(mdata); 
    activity = findactivity(mdata, 3);

    %% Plotting the graphs 

    unfoldActivity = Unfold(activity,missing,nan); 
    unfoldSamples = Unfold(ones(size(mdata,1),1),missing,0); 

    for i = 1:2
        index = i;
        plotdata = [unfoldSamples unfoldActivity];
        N = size(plotdata,1); 
        n = (0:Ts:(N-1)*Ts)'; 

        set = [n plotdata(:,index)]; 
        set = set(find(~isnan(set(:,2))),:);

        c = [1-set(:,2), set(:,2) , zeros(length(set),1)];
        scatter(ax2,set(:,1),ones(length(c),1)*i+poltId,6,c,'filled')
        hold on; 
    end
    
    desypos = descriptionStart+(poltId/2)*descriptiondelta;
    axes(ax1); % sets ax1 to current axes
    if(selectedMeter ~= ActiveMeters(end))
        line([desxpos .95],[desypos+(descriptiondelta/2) desypos+(descriptiondelta/2)],'LineStyle','--')
    end
    label = info{find(info{:,3}==selectedMeter),4};
    text(desxpos,desypos,label)
    
    disp([label num2str(selectedMeter)]);
   

    
poltId = poltId+2;     
end

ax = ax2;
ax.YTick = 1:poltId;
T = {'Avaliability','Activity'};
ax.YTickLabel = T(1 + mod( (1:poltId)-1, length(T) ) );

houretick = 0:3600*3:86400;

ax.XTick = houretick;
ax.XTickLabel = {'12:00', '15:00', '18:00', '21:00', '00:00'};
