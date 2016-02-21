function [ input ] = EnvGapFiller( input )
%ENVGAPFILLER Summary of this function goes here
%   Detailed explanation goes here
    n = 1:length(input);
    ok_mask = input ~= -1; 
    
    n_ok = n(ok_mask); 
    n_errors = n(~ok_mask);
    
    [pks,pkslocs] = findpeaks(input(ok_mask));
     pkslocs = n_ok(pkslocs); 
     
    [val,vallocs] = findpeaks(-input(ok_mask));
     vallocs = n_ok(vallocs);
    
    maxenv = spline(pkslocs,pks,n);
    minenv = spline(vallocs,-val,n);
    
    % find peak trent. 
    events = [pkslocs vallocs]'; 
    events = sortrows(events);
    eventMap = [ events(2:end) - events(1:end-1)];
    
    newPoints = []; 
    
    
    for ie = n_errors;
        
        prior = events(events<ie);
        post = events(events>ie);
        
        prior = prior(max(1,length(prior)-10):end);
        post = post(1:min(10,length(post)));
        
        if(~isempty(prior) && ~isempty(post))
            localEvents = [prior ; post];
            localmap = localEvents(2:end) - localEvents(1:end-1);
            
            p = polyfit(localEvents(1:end-1),localmap,3);
            y1 = ceil(polyval(p,prior(end)));
            
            nexttop = y1+prior(end);
            if(nexttop == ie && nexttop<post(1)&& nexttop>prior(end) && min(abs(localEvents - ie))>5 )
                newPoints = [newPoints ; ie];
            end
        end
    end
    
    events = [events ; newPoints]; 
    events = sortrows(events);
    
    one = events(1:2:end); 
    two = events(2:2:end);
  
    if(one(1) == pkslocs(1))
        input(one) = maxenv(one); 
        input(two) = minenv(two); 
    else 
        input(one) = minenv(one); 
        input(two) = maxenv(two); 
    end
    
    ok_mask(events) = 1; 
    
    input = spline(n(ok_mask),input(ok_mask),n);
end

