function [ pathCon, pathExp ] = CreateYaml( devices )
%CREATEYAML Summary of this function goes here
%   Detailed explanation goes here

[pathstr,name] = fileparts(mfilename('fullpath'));

baseConfig = [pathstr '\basefiles\baseConfig.yaml'];
baseExp =  [pathstr '\basefiles\baseExp.yaml'];

configuration = ReadYaml(baseConfig);
experiment = ReadYaml(baseExp);

experiment.experiment_name = {num2str(devices)};
configuration.experiment_name = num2str(devices); % devices list; 

configuration.num_appliances = length(devices); 
experiment.num_appliances = {length(devices)}; 

for index = 1:length(devices)
    
eval(['configuration.appliance',num2str(index) ' = ''TV' num2str(devices(index)) ''''] );
eval(['configuration.num_states_appliance',num2str(index), ' = 2']); 

eval(['experiment.appliance',num2str(index) ' = {''TV' num2str(devices(index)) '''}'] );
eval(['experiment.num_states_appliance',num2str(index), ' = {2}']); 

end

pathExp = strcat(pathstr,'\expiment1', '.yaml');
pathCon = strcat(pathstr,'\config1', '.yaml');

WriteYaml(pathCon, configuration);
WriteYaml(pathExp, experiment);

create_experiment(pathCon,pathExp);

end

