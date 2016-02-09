% This file is part of the project NILM-Eval (https://github.com/beckel/nilm-eval).
% Licence: GPL 2.0 (http://www.gnu.org/licenses/gpl-2.0.html)
% Copyright: ETH Zurich, 2014
% Author: Romano Cicchetti

% Create the setup files of an experiment
function create_setup_files(diff_parameter_names, diff_parameter_values, setup, setup_name, level, folder_setup_files)

    % path to store setup files
    if ~exist(folder_setup_files, 'dir')
        mkdir(folder_setup_files);
    end

    if level > length(diff_parameter_names)
        setup_name = strrep(setup_name, '.', '-');
        if isempty(setup_name) 
            setup_name = 'default';
        end
        setup.setup_name = setup_name;
        WriteYaml(strcat(folder_setup_files, '/', setup.setup_name, '.yaml'), setup);
    else
        values = diff_parameter_values{level};
        for i = 1:length(values)
            if iscell(values)
                value = values{i};
            else
                value = values(i);
            end
            parameter_name = diff_parameter_names(level);
            setup.(parameter_name{1}) = value;
            if isempty(setup_name)
                new_setup_name = num2str(value);
            else
                new_setup_name = strcat(setup_name, '_', num2str(value));
            end
            create_setup_files(diff_parameter_names, diff_parameter_values, setup, new_setup_name, level+1, folder_setup_files)
        end
    end
end
