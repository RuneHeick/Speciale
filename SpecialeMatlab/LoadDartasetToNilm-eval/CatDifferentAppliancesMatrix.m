function [ catMatrix, regLabels ] = CatDifferentAppliancesMatrix( values, labels )
%CATDIFFERENTAPPLIANCESMATRIX Summary of this function goes here
%   Detailed explanation goes here

    regLabels = {'TV','Stereo','Computer','DVD','Unknown Appliance 1','Unknown Appliance 2','Unknown Appliance 3','Unknown Appliance 4','Others'};

    catMatrix = zeros(length(regLabels),1); 
    
    for index = 1:length(values); 
        
        usage = round(values(index)); 
        lable = labels{index}; 
        if (usage > 0) 
        
             if(~isempty(findstr(lable, 'TV')) || ~isempty(findstr(lable, 'Flatscreen'))) 
                catMatrix(1) = catMatrix(1) + usage; 
                continue; 
             end
            
             if(~isempty(findstr(lable, 'Radio')) || ~isempty(findstr(lable, 'Stereo'))) 
                catMatrix(2) = catMatrix(2) + usage; 
                continue; 
             end
            
             if(~isempty(findstr(lable, 'PC')) || ~isempty(findstr(lable, 'Computer'))) 
                catMatrix(3) = catMatrix(3) + usage; 
                continue; 
             end
             
             if(~isempty(findstr(lable, 'DVD'))) 
                catMatrix(4) = catMatrix(4) + usage; 
                continue; 
             end
             
             if(~isempty(findstr(lable, 'Unknown'))) 
                slots = 5:8; 
                freesolts = 4+find(catMatrix(slots)==0); 
                
                catMatrix(freesolts(1)) = usage; 
                continue; 
             end
             
             catMatrix(9) = catMatrix(9) + usage; 
        
        end
    end


end

