function [ Quality, MeterInfo ] = FindQuality( dataSet, MeterInfo )
%FINDQU Summary of this function goes here
%   Detailed explanation goes here
    QualityParamters = @(x, unit)[
            %Time
            0 %max(x(2:end,1)-x(1:end-1,1))
            0 %min(x(2:end,1)-x(1:end-1,1))
            mean(x(2:end,1)-x(1:end-1,1))
            0 %var(x(2:end,1)-x(1:end-1,1))
            %Value
            0 %DoWithoutTimeDependency(@max , x(:,2), unit)
            0 %DoWithoutTimeDependency(@min, x(:,2), unit)
            0 %DoWithoutTimeDependency(@mean, x(:,2), unit)
            0 %DoWithoutTimeDependency(@var, x(:,2), unit)
            %NoSamples
            size(x,1)
            DoWithoutTimeDependency(@ActivityAnalyses, x, unit)
        ]; 

    
    parmetersTest = QualityParamters([1 1 1;1,1,1], 'dummy')'; 
    
    Quality = num2cell(NaN(size(MeterInfo,1),size(parmetersTest,2)),2); 
    
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
            Quality(Ii(i)) = num2cell(QualityParamters(dataSet{id(i):id(i+1)-1,:}, unit{1})',2);
        end;
    end; 

end

