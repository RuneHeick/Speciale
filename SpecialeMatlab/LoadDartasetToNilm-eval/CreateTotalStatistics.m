clear all
conn = database('dbservice','runeheick','cykeljernhest','Vendor','PostgreSQL','Server','dbservice.eng.au.dk')
setdbprefs('DataReturnFormat','table');

index = 1; 
database = cell(1,25); 
AllPorts = []; 
for house = 2:26
    set = GetHouseSet(conn,house); 
    database(index) = {set};
    
    AllPorts = [AllPorts set{2} set{3}];
    
    index = index +1; 
end

%% Download dataset

%DownloadDataSetFunc(conn, AllPorts);

%% Clean Data; 

%CleanDataFunc(AllPorts);

%%

m = 1; 
for house = database; 
    
    mainMeter = house{1}{2}; 
    submeters = house{1}{3}; 
    
    mainPower = GetPortTotalPower(mainMeter);
    others = mainPower;
    index = 1; 
    submeterPower = zeros(1, length(submeters)); 
    for submeter = submeters;
    
        submeterPower(index) = GetPortTotalPower(submeter); 
        others = others - submeterPower(index); 
        index = index+1; 
    end
    
    if(others>0)
    
        labels = house{1}{4};
        labels = {labels{:,:}, 'Others'};
        dataset = [submeterPower others];
        prc = round((dataset ./ sum(dataset))*100); 
        explode = zeros(1,length(labels)); 
        for i = 1:length(labels)
            labels{i} = [labels{i} ': ' num2str(prc(i)) '%'];
        end

        figure
        %subplot(1,length(houses),m)
        pie(dataset, explode, labels); 
        title(['House ' num2str(house{1}{1})]);
        pause(0.001);
    else
        disp('Error');
    end
    
    m = m+1; 
end


close(conn)