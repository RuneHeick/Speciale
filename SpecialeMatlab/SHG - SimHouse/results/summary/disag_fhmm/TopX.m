function [ topx ] = TopX( A, x )
%TOPX Summary of this function goes here
%   Detailed explanation goes here
    
    Asorted = sort(A,'descend');
    topx = Asorted(1:min(x,end));
    
end

