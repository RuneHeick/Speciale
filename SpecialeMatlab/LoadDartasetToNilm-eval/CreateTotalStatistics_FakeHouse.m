AllPorts = [37 41 91 97 117 171 217];

index =1;
for submeter = AllPorts;
    submeterPower(index) = GetPortTotalPower(submeter);
    index = index+1;
end

labels = {'TV 1','TV 2','TV 3','TV 4','TV 5','TV 6','TV 7'};
dataset = [submeterPower];
pie(AllPorts)
Colors = get(gca,'ColorOrder');

for t = [1,2,7]
    for combi = combnk(1:7,t)'

        subset = dataset(combi); 
        sublabels = labels(combi); 
        
        
        
        %Pie Chart
        prc = round((subset ./ sum(subset))*100);
        explode = zeros(1,length(sublabels));
        for i = 1:length(sublabels)
            sublabels{i} = [sublabels{i} ': ' num2str(prc(i)) '%'];
        end

        %subplot(1,length(houses),m)
        h = pie(subset, explode, sublabels);
        
        for k = 1 : length(subset);
            set(h(k*2-1), 'FaceColor', Colors(combi(k),:));
        end
        
        
        
        fig = gcf;
        fig.PaperPositionMode = 'auto';
        print(['FakeSubHouse/' num2str(combi')],'-dpng')
        pause(0.01);
    end
end
