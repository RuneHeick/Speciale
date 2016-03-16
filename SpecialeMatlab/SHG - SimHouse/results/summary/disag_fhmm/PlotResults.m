
TestPath = 'BreakDownTest2'; 

% Get a list of all files and folders in this folder.
files = dir(TestPath);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
    % Extract only those that are directories.
subFolders = files(dirFlags);

Bins = cell(2,7); 

index = 1; 
for i = 1:length(subFolders)
    folder = subFolders(i);
    tf = isstrprop(folder.name, 'digit');
        
    if sum(tf) ~= 0
            name = folder.name; 
            numbers = (name(find(tf)));
            
            binIndex = length(numbers); 
            
            load([TestPath '\' name '\default\summary.mat']);
            
            F1 = mean(summary.consumption.fscore);
            Acc = mean(summary.consumption.accuracy);
            
            F1(isnan(F1)) = 0; 
            Acc(isnan(Acc)) = 0; 
            
            Bins{1,binIndex} = [Bins{1,binIndex}; F1];
            Bins{2,binIndex} = [Bins{2,binIndex}; Acc];
    end
end

cellfun(@(x) mean(TopX(x,3)),Bins)