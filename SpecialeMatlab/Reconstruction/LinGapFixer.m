function [ x_gap ] = LinGapFixer( x_gap, i_gapStart, gapLength, traindelta )
%ENVGAPFIXER Summary of this function goes here
%   Detailed explanation goes here

n = (1:length(x_gap))';

i_trainLeft = (i_gapStart>traindelta)*(i_gapStart-traindelta) + (i_gapStart<=traindelta);
i_trainRigth = (length(x_gap)- (i_gapStart+gapLength) > traindelta)*(i_gapStart+gapLength+traindelta) + (length(x_gap)- (i_gapStart+gapLength) <= traindelta)*length(x_gap);

signalprior = x_gap(i_trainLeft:i_gapStart-1); 
signalpost = x_gap(i_gapStart+gapLength:i_trainRigth); 

signal = [signalprior ; signalpost];
signaln = [n(i_trainLeft:i_gapStart-1) ; n(i_gapStart+gapLength:i_trainRigth)];

yi = interp1q(signaln,signal,n(i_gapStart:i_gapStart+gapLength-1));

x_gap(i_gapStart:i_gapStart+gapLength-1) = yi; 

end

