clear all; 


errorpcr = 0.3; 
dataset = ones(1000,1);

errorset = dataset; 
errorset(rand(size(dataset))<errorpcr) = 0;