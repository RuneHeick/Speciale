function [ Quality, MeterInfo ] = FindQuality( dataSet, MeterInfo, T_start, T_end )
%FINDQU Summary of this function goes here
%   Detailed explanation goes here
        
    Quality = num2cell(NaN(size(MeterInfo,1),3),2); 
    
    if(isempty(dataSet))
        return;
    end
    
    [Ids, Ii] = intersect(MeterInfo{:,3}, dataSet{:,3}); 
    id = ones(size(Ids,1)+1,1);
    id(end) = size(dataSet,1)+1;
    for i = 1:size(Ids,1)
        % find Start and end indexes
        if(i<size(Ids,1))
            id(i+1) = find(dataSet{id(i):end,3} == Ids(i+1),1,'first')+(id(i)-1);            
        end
        
        if(isnan(MeterInfo{Ii(i),5}))
            MeterInfo{Ii(i),5} = dataSet{id(i),1};
            MeterInfo{Ii(i),6} = dataSet{id(i+1)-1,1};
        else 
            MeterInfo{Ii(i),6} = dataSet{id(i+1)-1,1};
        end
        
        if id(i)+1<id(i+1) % if more than one sample
            %Calculate Quality
            unit = MeterInfo{Ii(i),2};
            x = dataSet{id(i):id(i+1)-1,:};
            T_s = mean(x(2:end,1)-x(1:end-1,1));
            
                      
            startTime = (datenum(T_start)-datenum(datetime(1970,1,1)))*24*60*60 - (60*60*2);
            endTime = (datenum(T_end)-datenum(datetime(1970,1,1)))*24*60*60 - (60*60*2);
            
            T_p = (endTime - startTime);
            
            phi = (x(1,1)-startTime);        
            
            
            N_max = floor(((floor(T_p-phi))/T_s))+1; 
            N_observed = size(x,1);
                        

            Quality{Ii(i)} = [N_max, N_observed ,DoWithoutTimeDependency(@ActivityAnalyses, x, unit{1}) ];%num2cell(QualityParamters(dataSet{id(i):id(i+1)-1,:}, unit{1})',2);
        end;
    end; 

end

