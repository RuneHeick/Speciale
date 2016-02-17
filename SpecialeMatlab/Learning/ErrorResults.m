clear;

%% Weiss 
 
    path = 'ErrorTest\summary\weiss\weiss_initial\WeissError';
    % Get a list of all files and folders in this folder.
    files = dir(path);
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    % Extract only those that are directories.
    subFolders = files(dirFlags);

    index = 1; 
    for i = 3:length(subFolders)
     
        folder = subFolders(i);
        tf = isstrprop(folder.name, 'digit');        
        if sum(tf) ~= 0
            name = folder.name;
            
            tf(strfind(folder.name,'-')) = 1; 
            valname = name;
            valname(find(name == '-')) = '.';
            sampleRate = str2num(valname(find(tf)));
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
            summ.consumption.accuracy
            };
            index = 1 + index; 
        end
    end

    %% parson
    
    fpath = 'ErrorTest\summary\parsonAppliance\parsonAppliance_initial';
    % Get a list of all files and folders in this folder.
    files = dir(fpath);
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    % Extract only those that are directories.
    fsubFolders = files(dirFlags);


    for t = 3:length(fsubFolders)
    
    path = [fpath '\' fsubFolders(t).name];
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
            
            tf(strfind(folder.name,'-')) = 1; 
            valname = name;
            valname(find(name == '-')) = '.';
            sampleRate = str2num(valname(find(tf)));
            
            summ = load([path '\' name '\summary.mat' ] , 'summary');
            summ = summ.summary;
            
            data(:, index) = {'Parson' 
            sampleRate
            summ.appliance_names{1}
            max(summ.consumption.fscore)
            max(summ.consumption.recall)
            max(summ.consumption.precision)
            max(summ.consumption.tpr)
            max(summ.consumption.fpr)
            max(summ.consumption.accuracy)};
            index = 1 + index; 
        end
    end
    
    end
    
    %% fhmm
    
     path = 'ErrorTest\summary\disag_fhmm\fhmm_initialEX1\fhmmError_EX2';
    % Get a list of all files and folders in this folder.
    files = dir(path);
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    % Extract only those that are directories.
    subFolders = files(dirFlags);
    
    for i = 3:length(subFolders)
     
        folder = subFolders(i);
        tf = isstrprop(folder.name, 'digit');
        
        if sum(tf) ~= 0
            name = folder.name; 
            
            tf(strfind(folder.name,'-')) = 1; 
            valname = name;
            valname(find(name == '-')) = '.';
            sampleRate = str2num(valname(find(tf)));
            
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
               summ.consumption.fpr(n)
               summ.consumption.accuracy(n)};
               index = 1 + index;  
            end
        end
    end
    
    data = sortrows(data', [1 2 3])';
    
    %% Plot 1 
    close all; 
    
    algo = 1; %1-3
    appliance = 1;  %1-5
    feature = 9; %4-9
    
    titles = {'F1 score', 'Accuracy'};
    
index = 1;     
hFig = figure, 
set(hFig, 'Position', [500 500 800 300])
for feature = [4 9] 
    subplot(1,2,index);
    leg = cell(1,1);
    for algo = 1:3
        appdata = []; 
        for appliance = 1:5
            Appl = ((algo-1)*40+1:5:(40*algo))+(appliance-1);
            values =  [data{feature,Appl}];
            values(find(isnan(values))) = 0;
            sampleRate = [data{2,Appl}];
           
            appdata = [appdata ; values]; 
        end
        leg{algo} = data{1,Appl(1)};
        plot(sampleRate, mean(appdata));
        %xlim([0 0.3]);
        %ax = gca;
        
        % Convert y-axis values to percentage values by multiplication
        a=[cellstr(num2str(get(gca,'xtick')'*100))];
        % Create a vector of '%' signs
        pct = char(ones(size(a,1),1)*'%');
        % Append the '%' signs after the percentage values
        new_yticks = [char(a),pct];
        % 'Reflect the changes on the plot
        set(gca,'xticklabel',new_yticks) 
        
        
        xlabel('Error Rate')
        ylabel('Score')
        hold on; 
    end
    title(titles{index});
    
    index = index+1; 
end
legend(leg)

%% Plot 2 

for feature = [4 9]
    figure
    for appliance = 1:5
            leg = cell(1,1);
            for algo = 1:3
                Appl = ((algo-1)*40+1:5:(40*algo))+(appliance-1);
                appData =  [data{feature,Appl}];
                appData(find(isnan(appData))) = 0;
                sampleRate = [data{2,Appl}];

                subplot(3,2,appliance);
                plot(sampleRate, appData);
                %ylim([0.5 1]);
                hold on;
%                 ax = gca;
%                 ax.XTick = [1 20:20:60];
%                 ax.XTickLabel = {'1 Hz', '1/20 Hz', '1/40 Hz', '1/60 Hz'};
%                 xlabel('Sample Rate')
%                 ylabel('Score')
                leg{algo} = data{1,Appl(1)};
            end
            title(data{3,Appl(1)})
    end
            legend(leg)
end



