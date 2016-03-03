dataPath = 'downloadedDataClean';
savePath = 'smartHG15'
house = 1;

realNum = 15;
flipreal = false; 

% Collection of housenr, mainmeter, submeter; 
houses = { {1,[15],[19 21 23]}, {2,[85],[87 89 91 93]} , {3,[165],[167 171 173]} }; 


for house = houses
        
    %% Mainmeter
    load('MMValues');
    
    mainmeterdata = house{1};
    
    
    mainmeter = struct();
    mainmeter.powerallphases =  mainmeterdata{2}(1);
    mainmeter.powerl1 = [];
    mainmeter.powerl2 = [];
    mainmeter.powerl3 = [];
    mainmeter.currentneutral = [];
    mainmeter.currentl1 = 1206;
    mainmeter.currentl2 = 1207;
    mainmeter.currentl3 = 1208;
    mainmeter.voltagel1 = 1209;
    mainmeter.voltagel2 = 1210;
    mainmeter.voltagel3 = 1211;
    mainmeter.phaseanglevoltagel2l1 = [];
    mainmeter.phaseanglevoltagel3l1 = [];
    mainmeter.phaseanglecurrentvoltagel1 = 1212;
    mainmeter.phaseanglecurrentvoltagel2 = 1213;
    mainmeter.phaseanglecurrentvoltagel3 = 1214;
    mainmeter.household = mainmeterdata{1}(1);
    mainmeter.insertedValues = insertedValues;
    
    %% Submeters
    
    ports = mainmeterdata{3};
    
     %% mainmeter import.
    
    load(sprintf('%02d', mainmeter.household ));
    
    simdays = evalDays(realNum+1:end,:); 
    if(flipreal)
        simdays = evalDays(1:realNum,:);        
    end
    
    listing = dir([dataPath '\' num2str(mainmeter.powerallphases)])
    mkdir([savePath '\smartmeter\' sprintf('%02d', mainmeter.household ) ]);
    for index = 3:length(listing)
        file = listing(index).name;
        [pathstr,name,ext] = fileparts(file);
        date = datetime(name);
        

        ispresent = isempty(strmatch(name, simdays, 'exact'));
        if ispresent
            values = load([dataPath '\' num2str(mainmeter.powerallphases) '\' file]);
            data = values.data;
        else 
            data = GetSimMeter( dataPath, ports, file );
        end

        mmday = struct();
        mmday.powerallphases = data;
        mmday.household = mainmeter.household;
        mmday.insertedValues = mainmeter.insertedValues;
        
        varname = ['Appliance' sprintf('%02d', mmday.household ) '00' datestr(date,'yyyymmdd')];
        eval( [varname ' = mmday']);
        save([savePath '\smartmeter\' sprintf('%02d', mainmeter.household ) '\' name], varname);
        eval( ['clear ' varname]);
    end
  
    
    %% Submeter import
    
    plugID = 0;
    for port = ports
        plugID = plugID +1;
        plugsave = [savePath '\plugs\' sprintf('%02d', mainmeter.household ) '\' sprintf('%02d', plugID ) ];
        mkdir(plugsave);
        listing = dir([dataPath '\' num2str(port)])
        for index = 3:length(listing)
            file = listing(index).name;
            values = load([dataPath '\' num2str(port) '\' file]);
            data = values.data;
            
            
            [pathstr,name,ext] = fileparts(file);
            date = datetime(name);
            
            mmday = struct();
            mmday.consumption = data;
            mmday.household = mainmeter.household;
            mmday.plug = plugID;
            mmday.insertedValues = mainmeter.insertedValues;
            
            varname = ['Appliance' sprintf('%02d', mmday.household ) sprintf('%02d', plugID ) datestr(date,'yyyymmdd')];
            eval( [varname ' = mmday']);
            save([plugsave '\' name], varname);
            eval( ['clear ' varname]);
        end
        
    end    
    
   

end