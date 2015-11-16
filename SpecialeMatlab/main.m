clear all, close all, clc;
load('Data.mat');

tic;
set = DataSetCreator(Data, MeterInfo);
toc
%%

DataID = 2;
figure,
PlotIndex = 1; 
for i = 1:length(set)
    if(strcmp(set{i,3},'InstantaneousDemand')) %InstantaneousDemand CurrentSummationDelivered
        data = set{i,2};
        subplot(5,1,PlotIndex)
        PlotIndex = PlotIndex +1;
        plot(data(2:end,1),data(2:end,DataID))
        legend(set{i,5})
    end
end