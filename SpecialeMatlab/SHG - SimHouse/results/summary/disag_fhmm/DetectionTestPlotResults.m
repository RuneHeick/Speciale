
TestPath = 'ModelCompletnessTest'; 

% Get a list of all files and folders in this folder.
files = dir(TestPath);

% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];

% Extract only those that are directories.
subFolders = files(dirFlags);

BinsF1 = cell(7,7); 
BinsAcc = cell(7,7); 

index = 1; 
for i = 1:length(subFolders)
    folder = subFolders(i);
    tf = isstrprop(folder.name, 'digit');
        
    if sum(tf) ~= 0
            name = folder.name; 
            numbers = (name(find(tf)));
            
            load([TestPath '\' name '\default\summary.mat']);
            
            for n = 1:length(numbers)

                submeterId = str2num(numbers(n)); 
                
                F1 = summary.consumption.fscore(n);
                Acc = summary.consumption.accuracy(n);

                F1(isnan(F1)) = 0; 
                Acc(isnan(Acc)) = 0; 

                BinsF1{length(numbers),submeterId} = [BinsF1{length(numbers),submeterId}; floor(100*F1)/100];
                BinsAcc{length(numbers),submeterId} = [BinsAcc{length(numbers),submeterId}; floor(100*Acc)/100];
            end
    end
end

F1Scores = cellfun(@(x) max(x),BinsF1)

AccScores = cellfun(@(x) max(x),BinsAcc)

subplot(2,1,1)
plot(F1Scores,'-o');
ylabel('F1 Score');
xlabel('Number of appliances in model');

fig = gca; 
fig.XTick
fig.XTickLabel = cellfun(@(x) [x ' of 7' ],fig.XTickLabel,'UniformOutput', false)


subplot(2,1,2)
plot(AccScores,'-o')
ylabel('Accuracy Score'); 
xlabel('Number of appliances in model');

fig = gca; 
fig.XTick
fig.XTickLabel = cellfun(@(x) [x ' of 7' ],fig.XTickLabel,'UniformOutput', false)

legend1 = legend(gca,'show',{'TV 1','TV 2','TV 3','TV 4','TV 5','TV 6','TV 7'});
set(legend1,'Position',[0.911714423256587 0.735429941860465 0.0834932812630786 0.189583328117927]);




