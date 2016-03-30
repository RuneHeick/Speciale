
configuration_input = 'input/configurations/fhmm_Tv.yaml';
experiment_input = 'input/experiments/fhmm/fhmm_Tv_Case.yaml';


create_experiment(configuration_input,experiment_input);
run_experiment(configuration_input,experiment_input);