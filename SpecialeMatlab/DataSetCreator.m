function [ set ] = DataSetCreator( initial_data, Meter_Info)
%DATASETCREATOR Summary of this function goes here
%   Detailed explanation goes here

    set = {}
    sorted_data = sortrows(initial_data, [4 ,2]);
    sorted_MeterInfo = sortrows(Meter_Info, 5); 
    
    currentPort = 99999999999; 
    setIndex = 0; 
    infoIndex = 0; 
    lastValue = 0; 
    lastTime = 0; 
    firstTime = 0;
    for n = 1:height(sorted_data)
        
        if(sorted_data{n,4} ~= currentPort)
            infoIndex = infoIndex+1; 
            currentPort = sorted_data{n,4}; 
            newIndex = size(set,1)+1; 
            set{newIndex, 1} = currentPort;
            set{newIndex, 2} = [];
            set{newIndex, 3} = sorted_MeterInfo{infoIndex,3};
            set{newIndex, 4} = sorted_MeterInfo{infoIndex,4};
            set{newIndex, 5} = sorted_MeterInfo{infoIndex,6};
            setIndex = setIndex +1 ;
            lastValue = 0; 
            lastTime = 0; 
            firstTime = 0;
        end
        
        dataset = set{newIndex, 2};
        datasetIndex = size(dataset,1)+1;
        
        currentTime = ToDate(sorted_data{n,2});
        
        if firstTime == 0
            firstTime = currentTime;
        end
        
        currentValue = sorted_data{n,3};
        dataset(datasetIndex,1:4) = [currentTime-firstTime ,currentValue ,currentValue-lastValue,(currentTime-lastTime)*86400 ];
        lastValue = currentValue;
        lastTime = currentTime;
        
        set{newIndex, 2} = dataset;
    end 
   
end

