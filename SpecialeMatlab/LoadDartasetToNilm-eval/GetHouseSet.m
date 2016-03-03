function [ houseSet ] = GetHouseSet(conn, houseNr )
%GETHOUSESET Summary of this function goes here
%   Detailed explanation goes here
    unitvalue = 'milliwatt';
    Mainvalue = 'Main Meter';
    info = GetHouseInfo(conn,houseNr);
    
    cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
    Index = cellfun(cellfind(unitvalue),info{:,2});
    
    ports = info{Index,3}';
    names = info{Index,4}';
    
    mainlogic =  cellfun(cellfind(Mainvalue),names); 
    
    mainports = ports(mainlogic);
    subports = ports(~mainlogic);
    subnames = names(~mainlogic);
    
    houseSet = {houseNr, mainports, subports, subnames};
    
end

