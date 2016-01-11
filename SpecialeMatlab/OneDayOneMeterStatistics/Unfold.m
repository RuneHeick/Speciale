function [ newset ] = Unfold( set, missing, placeholder )
%UNFOLD Summary of this function goes here
%   Detailed explanation goes here
    more = sum(missing(:,2)); 
    newset = ones(size(set,1)+more,1)*placeholder;
    
    lastIndex = 1; 
    skip = 0; 
    for i = 1:size(missing,1)
        index = missing(i,1); 
        count = missing(i,2); 
        
        newset(lastIndex+skip:index+skip) = set(lastIndex:index);
        
        skip=skip+count; 
        lastIndex = index+1;
    end
    newset(lastIndex+skip:end) = set(lastIndex:end);
     
end

