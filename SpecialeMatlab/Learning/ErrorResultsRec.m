clear;

%% Weiss 
 
    path = 'ErrorRec\summary\weiss\weiss_initial\WeissErrorRec';
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
            
            type = 'Non';
            if(~isempty(findstr(name, 'Env')))
                type = 'Env';
            elseif(~isempty(findstr(name, 'Linear')))
                type = 'Linear';
            end
            
            data(:, index) = {'Weiss' 
            sampleRate
            summ.appliance_names{1}
            summ.consumption.fscore
            summ.consumption.recall
            summ.consumption.precision
            summ.consumption.tpr
            summ.consumption.fpr
            summ.consumption.accuracy
            type
            };
            index = 1 + index; 
        end
    end

    %% parson
    
    fpath = 'ErrorRec\summary\parsonAppliance\parsonAppliance_initial';
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
            
            type = 'Non';
            if(~isempty(findstr(name, 'Env')))
                type = 'Env';
            elseif(~isempty(findstr(name, 'Linear')))
                type = 'Linear';
            end
            
            data(:, index) = {'Parson' 
            sampleRate
            summ.appliance_names{1}
            max(summ.consumption.fscore)
            max(summ.consumption.recall)
            max(summ.consumption.precision)
            max(summ.consumption.tpr)
            max(summ.consumption.fpr)
            max(summ.consumption.accuracy)
            type};
            index = 1 + index; 
        end
    end
    
    end
    
    %% fhmm
    
     path = 'ErrorRec\summary\disag_fhmm\fhmm_initialEX1\fhmmError_EX3';
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
            
            type = 'Non';
            if(~isempty(findstr(name, 'Env')))
                type = 'Env';
            elseif(~isempty(findstr(name, 'Linear')))
                type = 'Linear';
            end
            
            for n = 1:length(summ.appliance_names)
                
               data(:, index) = {'FHMM' 
               sampleRate
               summ.appliance_names{n}
               summ.consumption.fscore(n)
               summ.consumption.recall(n)
               summ.consumption.precision(n)
               summ.consumption.tpr(n)
               summ.consumption.fpr(n)
               summ.consumption.accuracy(n)
               type};
               index = 1 + index;  
            end
        end
    end
    
    data = sortrows(data', [1 10 2 3])';
    
%% Plot 1 
    
for algoJump = 1:3

    for feature = [4]
        figure
        for appliance = 1:5
                leg = cell(1,1);
                for algoIndex = 1:3
                    algo = ((algoJump-1)*3)+(algoIndex);
                    Appl = ((algo-1)*40+1:5:(40*algo))+(appliance-1);
                    appData =  [data{feature,Appl}];
                    appData(find(isnan(appData))) = 0;
                    sampleRate = [data{2,Appl}];

                    subplot(3,2,appliance);
                    plot(sampleRate, appData);
                    %ylim([0.5 1]);
                    hold on;
   
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
                    
                    leg{algoIndex} =  [ data{10,Appl(1)} ' - ' data{1,Appl(1)}];
                end
                title(data{3,Appl(1)})
        end
                legend(leg)
    end

    end

    %% Plot 2 
figure
for algoIndex = 1:3

        feature = 4;
        meanvalue = []; 
        
        for appliance = 1:5
                for algoJump = 1:3
                    algo = ((algoJump-1)*3)+(algoIndex);
                    Appl = ((algo-1)*40+1:5:(40*algo))+(appliance-1);
                    appData =  [data{feature,Appl}];
                    appData(find(isnan(appData))) = 0;
                    sampleRate = [data{2,Appl}];

                    
                    meanvalue = [ meanvalue ; appData ];
                    
                    
                end
        end
        leg{algoIndex} =  data{10,Appl(1)};
        
        plot(sampleRate, mean(meanvalue,1))
        hold on; 
end
legend(leg)

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


