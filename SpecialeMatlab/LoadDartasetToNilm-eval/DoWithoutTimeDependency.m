function [ ret ] = DoWithoutTimeDependency( func, x, unit )
%DOWITHOUTTIMEDE Summary of this function goes here
%   Detailed explanation goes here

    
    if (isempty(strfind(unit,'*hour')) || size(x,1)<2) 
        ret(1) = feval(func,x);
    else
        ret(1) = feval(func,x(2:end,:)-x(1:end-1,:)) ;
    end

end

