dataPath = 'smartHGCase\plugs\0';
houseInfo = cell(1,4); 
index = 1; 
for submeter = [1 2 4 5]
    
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

houseInfoChanged = cell(1,4); 


H = 3; 

realsig = (houseInfo{H}(1,:)>20)*50; 

realfiltered = MergeFilter(realsig,500);
realfiltered = TopFilter(realfiltered, 700); 



% Guesses 

filtered = TopFilter(houseInfo{H}(2,:), 700); 
filtered = MergeFilter(filtered,1000);
filtered = TopFilter(filtered, 1500); 
filtered = MergeFilter(filtered,3000);




plot(filtered > 20); 
hold on;
plot(realfiltered > 20); 
hold off



