
AppliancesPort = [37 41 91 97 117 171 217 ]; 

DataSetCreator(1, AppliancesPort, 'SimDataProject\downloadedDataClean', 'data\FakeDS');

ApplianceID = 1:length(AppliancesPort); 

for appsCount = 1:length(AppliancesPort)


    for combi = combnk(ApplianceID,appsCount)'
    
        testDevices = combi';
        [conpath, expPath] = CreateYaml(testDevices); 
        
        creationApp = zeros(1,length(AppliancesPort)); 
        creationApp(testDevices) = AppliancesPort(testDevices); 
              
        
        
        save_evaluation_days();
        
        run_experiment(conpath,expPath); 
    
    end
    
end