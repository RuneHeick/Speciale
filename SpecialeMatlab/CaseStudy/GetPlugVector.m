dataPath = 'smartHGCase\plugs\0';
houseInfo = cell(1,5); 
index = 1; 
for submeter = [1 2 4 5 6]
    
    infPath = ['fhmm_Tv_Case\' num2str(submeter) '\result1' ]; 
    infdata = load(infPath);
    
    
    validDays = infdata.result.evaluation_and_training_days{1};
    meterconsumtion = []; 
    for dayIndex = 1:size(validDays,1);
        
        day = validDays(dayIndex,:);
        dayPath = [dataPath num2str(submeter) '\01\' day '.mat'];
        
        daydata = load(dayPath);
        fields = fieldnames(daydata);
        item = daydata.(fields{1});
        
        meterconsumtion = [ meterconsumtion item.consumption']; 
    end
    
    meterconsumtion(2,:) = infdata.result.consumption;
    houseInfo{index} = meterconsumtion; 
    
    index = index + 1; 
end

%%
H = 2; 

plot(houseInfo{H}(1,:)); 
hold on; 
plot(houseInfo{H}(2,:)); 

%% True
sizeL = 24*60*60*42;
houseInfoChanged = zeros(2,sizeL); 


for H = 1%:4; 

realsig = (houseInfo{H}(1,:)>20)*50; 

realfiltered = MergeFilter(realsig,500);
realfiltered = TopFilter(realfiltered, 700); 



% Guesses 
infsig = houseInfo{H}(2,:);
filtered = TopFilter(infsig, 700); 
filtered = MergeFilter(filtered,1000);
% filtered = TopFilter(filtered, 1500); 
% filtered = MergeFilter(filtered,3000);

inf = (filtered > 20)*1;
realuf = (infsig > 20)*1;
real = (realfiltered > 20)*1;



%% plot
for week = 2;
interval = 24*60*60*7; 

siminf = inf(interval*(week-1)+1:interval*(week)-24*60*60*6);
simreal = real(interval*(week-1)+1:interval*(week)-24*60*60*6);
siminfUf = (infsig(interval*(week-1)+1:interval*(week)-24*60*60*6) > 20)* 1 ;

%% find statistics 

val = siminfUf; 

TP = sum(val == 1 .* simreal==1);
FP = sum(val == 1 .* simreal==0);

TN = sum(val == 0 .* simreal==0);
FN = sum(val == 0 .* simreal==1);

acc = (TP+TN) / (TP + TN+ FP +FN)

recall = TP/(TP + FN); 
prec = TP/ (TP + FP); 

f1 =  (2*TP)/(2*TP+FP+FN)


% subplot(2,1,1)
% hold on;
% plot(simreal,'g','LineWidth',2);
% plot(siminfUf,'b');
% ylim([0 1.1]);
% 
% fig = gca; 
% fig.XTick = 0:6*60*60:24*60*60;
% fig.XTickLabel = {'12 AM','6 AM','12 PM','6 PM', '12 AM'}; 
% fig.YTick = [0 1];
% fig.YTickLabel = {'TV Off' 'TV On'}; 
% title('Raw Disaggregation');
% 
% subplot(2,1,2)
% hold on;
% plot(simreal,'g','LineWidth',2);
% plot(siminf,'b');
% ylim([0 1.1]);
% fig = gca; 
% fig.XTick = 0:6*60*60:24*60*60;
% fig.XTickLabel = {'12 AM','6 AM','12 PM','6 PM', '12 AM'}; 
% fig.YTick = [0 1];
% fig.YTickLabel = {'TV Off' 'TV On'}; 
% title('Appliance Norm Filter');
% 
% legend({'Actual', 'Inferred', }); 
% 
% hold off;
end


%%


houseInfoChanged(1,:) = houseInfoChanged(1,:) + inf(1:sizeL);
houseInfoChanged(2,:) = houseInfoChanged(2,:) + real(1:sizeL);

end

%% Plot 2 weeks

week = 3; 

interval = 24*60*60*7; 

siminf = houseInfoChanged(1,interval*(week-1)+1:interval*(week));
simreal = houseInfoChanged(2,interval*(week-1)+1:interval*(week));

err = immse(siminf,simreal)


plot(siminf);
hold on;
plot(simreal,'g');
hold off;

legend({'Inferred', 'Actual'}); 
ylabel('TV Viewership')
xlabel('Time')
xlim([0 6e5]); 
fig = gca; 
fig.XTick = 0:6e5/7:6e5;
fig.XTickLabel = {}; 

%%
interval = 0; 
total = [];
for day = 1:floor(42)

    periodTime = []; 
     
    for l = 1:8     

        interval = interval +1; 
        
        inf = mean(houseInfoChanged(1,3*60*60*(interval-1)+1:3*60*60*(interval))); 
        real = mean(houseInfoChanged(2,3*60*60*(interval-1)+1:3*60*60*(interval))); 
        
        periodTime = [ periodTime , [(inf) ; (real)]]; 
        
    end
    disp(periodTime)
    total = [total ; periodTime];
end

for weekday = 1:7
    clc
    weekday
    %round(mean(total(weekday:7*2:42*2,:)).*100) / 100
    
    
    round(mean(total(weekday+1:7*2:42*2,:))*100)/100
    pause()
end

