
configuration_input = 'input/configurations/parsonStates_initial.yaml';
experiment_input = 'input/experiments/parson/SHG2/TV_States.yaml';


create_experiment(configuration_input,experiment_input);
run_experiment(configuration_input,experiment_input);