
configuration_input = 'input/configurations/parsonAppliance_initial.yaml';
experiment_input = 'input/experiments/parson/SHG2/PC_EX1.yaml';


create_experiment(configuration_input,experiment_input);
run_experiment(configuration_input,experiment_input);