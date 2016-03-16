
configuration_input = 'input/configurations/parsonAppliance_initial.yaml';
experiment_input1 = 'input/experiments/parson/SHG2/TV_EX1.yaml';
experiment_input2 = 'input/experiments/parson/SHG2/Stereo_EX1.yaml';
experiment_input3 = 'input/experiments/parson/SHG2/PC_EX1.yaml';

create_experiment(configuration_input,experiment_input1);
run_experiment(configuration_input,experiment_input1);

create_experiment(configuration_input,experiment_input2);
run_experiment(configuration_input,experiment_input2);

create_experiment(configuration_input,experiment_input3);
run_experiment(configuration_input,experiment_input3);