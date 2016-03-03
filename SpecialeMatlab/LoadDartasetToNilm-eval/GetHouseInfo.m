function [ Info ] = GetHouseInfo( db_con, houseNr )
%GETHOUSEINFO Summary of this function goes here
%   Detailed explanation goes here 
    text = fileread('SqlScripts/Get Home.sql');
    text = strrep(text,'4',int2str(houseNr));
    Info = fetch(db_con,text);
    if ~isempty(Info)
         Info = sortrows(Info, 3);
    end
end

