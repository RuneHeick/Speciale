clear;

%% Weiss 
 
    path = 'summary\weiss\weiss_initial\WeissEx1';
    % Get a list of all files and folders in this folder.
    files = dir(path);
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    % Extract only those that are directories.
    subFolders = files(dirFlags);

    index = 1; 
    for i = 1:length(subFolders)
     
        folder = subFolders(i);
        tf = isstrprop(folder.name, 'digit');
        
        if sum(tf) ~= 0
            name = folder.name; 
            sampleRate = str2num(name(find(tf)));
            summ = load([path '\' name '\summary.mat' ] , 'summary');
            summ = summ.summary;
            
            data(:, index) = {'Weiss' 
            sampleRate
            summ.appliance_names{1}
            summ.consumption.fscore
            summ.consumption.recall
            summ.consumption.precision
            summ.consumption.tpr
            summ.consumption.fpr
            };
            index = 1 + index; 
        end
    end

    %% 
    
    path = 'summary\parsonAppliance\parsonAppliance_initial\parsonAppliance_EX1_training';
    % Get a list of all files and folders in this folder.
    files = dir(path);
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    % Extract only those that are directories.
    subFolders = files(dirFlags);

    for i = 1:length(subFolders)
     
        folder = subFolders(i);
        tf = isstrprop(folder.name, 'digit');
        
        if sum(tf) ~= 0
            name = folder.name; 
            sampleRate = str2num(name(find(tf)));
            summ = load([path '\' name '\summary.mat' ] , 'summary');
            summ = summ.summary;
            
            data(:, index) = {'Parson' 
            sampleRate
            summ.appliance_names{1}
            max(summ.consumption.fscore)
            max(summ.consumption.recall)
            max(summ.consumption.precision)
            max(summ.consumption.tpr)
            max(summ.consumption.fpr)};
            index = 1 + index; 
        end
    end
    
    %% fhmm
    
     path = 'summary\disag_fhmm\fhmm_initialEX1\fhmm_EX1';
    % Get a list of all files and folders in this folder.
    files = dir(path);
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    % Extract only those that are directories.
    subFolders = files(dirFlags);
    
    for i = 1:length(subFolders)
     
        folder = subFolders(i);
        tf = isstrprop(folder.name, 'digit');
        
        if sum(tf) ~= 0
            name = folder.name; 
            sampleRate = str2num(name(find(tf)));
            
            summ = load([path '\' name '\summary.mat' ] , 'summary');
            summ = summ.summary;
            
            for n = 1:length(summ.appliance_names)
                
               data(:, index) = {'FHMM' 
               sampleRate
               summ.appliance_names{n}
               summ.consumption.fscore(n)
               summ.consumption.recall(n)
               summ.consumption.precision(n)
               summ.consumption.tpr(n)
               summ.consumption.fpr(n)};
               index = 1 + index;  
            end
        end
    end
    
    data = sortrows(data', [1 2 3])';
    
    %% Plot 1 
    close all; 
    
    algo = 1; %1-3
    appliance = 1;  %1-5
    feature = 7; %4-8
    
    for appliance = 1:4
        Appl = ((algo-1)*35+1:5:(35*algo))+(appliance-1);
        appData =  [data{feature,Appl}];
        appData(find(isnan(appData))) = 0;
        sampleRate = [data{2,Appl}];
        
        plot(sampleRate, appData);
        hold on;
    end