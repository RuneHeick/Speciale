datasetPath = 'data\smartHG'
method = 'Env';
traindays = 0; 


savepath =  [datasetPath '-' method];
copyfile(datasetPath,savepath);


for datapath = {'smartmeter\01','plugs\01\01','plugs\01\02','plugs\01\03','plugs\01\04' }; 

    for i = traindays+1:length(evalDays);
        disp([ num2str(i) ' of ' num2str(length(evalDays))])
        data = load([datasetPath '\' datapath{1} '\' evalDays(i,:) '.mat']); 

        fields = fieldnames(data);

        value = CreateErrorSignal(data.(fields{1}), 0); 
        value = GapFillingSignal(value, method);

        eval([ fields{1} ' =  value']);
        save([savepath '\' datapath{1} '\' evalDays(i,:)], fields{1}); 
        eval([ 'clear ' fields{1}]);
    end

end