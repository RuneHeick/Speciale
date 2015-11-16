function [ ny ] = LinearInterp( x, y, n, limit )
%LINEARINTERP Summary of this function goes here
%   Detailed explanation goes here

    ny = nan(size(n));
    startId = 1;
    for i = 1:length(x)
        if(x(i) > n(startId))
        
            x2 = x(i);
            y2 = y(i); 
            
            x1 = x(i-1);
            y1 = y(i-1);
            
            a = (y2-y1)/(x2-x1); 
            b = y1-x1*a;
            
            ny(startId) = a*n(startId);
            
            startId = startId+1; 
        end
    end

end

