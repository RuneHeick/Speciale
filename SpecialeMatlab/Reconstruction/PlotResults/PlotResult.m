    res = CollectedResult; 

    knownMese = []
    
    
    for i = 1:size(res,1)
       GapSize = res{i,1};
       data = res{i,2};
       for n = 1:size(data,1)  
           known = data{n,1};
           rec = data{n,2};
        
           values = zeros(1,5); 
           for k = 1:size(rec,2) 
            
               data2 = rec{1,k}(2:end);
               values = values + cellfun(@(x) x(1),data2); 
           
           end
           
           values = values./size(rec,2);
           knownMese = [knownMese ;  [known GapSize values]]
       end
        
        
    end
    
    surf(knownMese(:,1),knownMese(:,2), knownMese(:,3)); 
    