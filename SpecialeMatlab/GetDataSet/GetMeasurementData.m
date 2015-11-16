function [ data ] = GetMeasurementData( conn, houseNr, from, to, data )
%GETMEASUREMENTDATA Summary of this function goes here
%   Detailed explanation goes here

    text = fileread('SqlScripts/Gethomesmeasurement.sql');
    text = strrep(text,'4',int2str(houseNr));
    text = strrep(text,'fromtime',datestr(from,'yyyy-mm-dd HH:MM:SS.FFF'));
    text = strrep(text,'totime',datestr(to,'yyyy-mm-dd HH:MM:SS.FFF'));

    newData = fetch(conn,text);
    if ~isempty(newData)
        newData = sortrows(newData, [3 1]);
        
        [Ids, Ii] = intersect(cell2mat(data(:,1)), newData{:,3});
        id = ones(size(Ids,1)+1,1);
        id(end) = size(newData,1)+1;
        for i = 1:size(Ids,1)
            % find Start and end indexes
            if(i<size(Ids,1))
                id(i+1) = find(newData{id(i):end,3} == Ids(i+1),1,'first')+(id(i)-1);
            end
            
            if id(i)+1<id(i+1)
                %Calculate Quality
                index = find(cell2mat(data(:,1)) == Ids(i),1,'first');
                data{index, 2} = [data{index, 2}; newData(id(i):id(i+1)-1,:)];
            end;
    end; 
        
    end

end

