% This file is part of the project NILM-Eval (https://github.com/beckel/nilm-eval).
% Licence: GPL 2.0 (http://www.gnu.org/licenses/gpl-2.0.html)
% Copyright: ETH Zurich, 2014
% Author: Romano Cicchetti

function [result] = disag_fhmm(evaluation_and_training_days, setup, fid)
    
    % load parameters of algorithm
    dataset = setup.dataset;
    household = setup.household;
    granularity = setup.granularity;
    filteringMethod = setup.filtering;
    filtLength = setup.filtLength;
    evaluation_days = evaluation_and_training_days{1};
    training_days = evaluation_and_training_days{2};
    num_appliances = setup.num_appliances;
    
    % prepare plug and smart meter data for training
    appliances = {};
    sum_of_plug_data = zeros(1, (size(training_days,1) * 24 * 3600)/granularity);
%     sum_of_plug_data = sum_of_plug_data(1:100);
    for i=1:num_appliances
        appliance = struct;
        eval(['appliance.name = setup.appliance' num2str(i) ';']);
        appliance.id = getApplianceID(appliance.name);
        fprintf('Reading data from appliance %s - id: %d\n', appliance.name, appliance.id);
        appliance.plug_data_training = read_plug_data(dataset, household, appliance.id, training_days, granularity);
%         appliance.plug_data_training = appliance.plug_data_training(1:100);
        sum_of_plug_data = sum_of_plug_data + appliance.plug_data_training;
        eval(['appliance.num_states = setup.num_states_appliance' num2str(i) ';']);
        
        appliances{i} = appliance;
    end
    
    % prepare "other" plug
    if setup.states_other > 0
        smart_meter_data_training = read_smartmeter_data(dataset, household, training_days, granularity, 'powerallphases');
%         smart_meter_data_training = smart_meter_data_training(1:100);
        other_data = smart_meter_data_training - sum_of_plug_data;    
        other_appliance = struct;
        appliance.name = 'other';
        appliance.plug_data_training = other_data;
        appliance.num_states = setup.states_other;
        appliances{end+1} = appliance;
    end
    
    smart_meter_data_evaluation = read_smartmeter_data(dataset, household, evaluation_days, granularity, 'powerallphases');
    smart_meter_data_evaluation = CreateErrorSignal(smart_meter_data_evaluation, setup.errorRate); 
    smart_meter_data_evaluation = GapFillingSignal(smart_meter_data_evaluation, setup.gapMethod); 
    
    % perform training
    pyObj = py.fhmm.Fhmm();
    pyObj.train(appliances);
    
    fprintf('Done with training');
    
    ret = pyObj.disaggregate(smart_meter_data_evaluation);
    
    states = cell(ret){1};
    consumption = cell(ret){2};
    
    
    
    result = struct;
    inferred_consumption = zeros(num_appliances, length(smart_meter_data_evaluation));
    appliance_names = {};
    for i=1:num_appliances
        eval(['name = setup.appliance' num2str(i) ';']);
        appliance_names{end+1} = name;
        
        %Remove whitespaces
        consumptionClean = py.dictClean3.removew(consumption);
        name(ismember(name,' ,.:;!')) = [];
        
        % eval(['app_result.states = cell2mat(cell(py.list(struct(states).' app_result.name ')));']);
        eval(['cons = cell2mat(cell(py.list(struct(consumptionClean).' name ')));']);
        inferred_consumption(i,:) = cons;
    end
    result.appliance_names = appliance_names;
    result.consumption = inferred_consumption;
end

    