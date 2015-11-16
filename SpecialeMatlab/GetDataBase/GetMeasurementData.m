function [ data ] = GetMeasurementData( conn, houseNr, from, to )
%GETMEASUREMENTDATA Summary of this function goes here
%   Detailed explanation goes here

    text = fileread('SqlScripts/Gethomesmeasurement.sql');
    text = strrep(text,'4',int2str(houseNr));
    text = strrep(text,'fromtime',datestr(from,'yyyy-mm-dd HH:MM:SS.FFF'));
    text = strrep(text,'totime',datestr(to,'yyyy-mm-dd HH:MM:SS.FFF'));

    data = fetch(conn,text);
    if ~isempty(data)
        data = sortrows(data, [3 1]);
    end

end

