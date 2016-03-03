
houses = { {3,[15],[19 21 23],{'PC','TV 1','TV 2'}}, {10,[85],[87 89 91 93],{'PC','DVD Player','TV','Stereo'}} , {18,[165],[167 169 171 173],{'TV 1','TV Reciver','TV 2', 'Lamp'}} }; 
m = 1; 
for house = houses; 
    
    mainMeter = house{1}{2}; 
    submeters = house{1}{3}; 
    
    mainPower = GetPortTotalPower(mainMeter);
    others = mainPower;
    index = 1; 
    submeterPower = zeros(1, length(submeters)); 
    for submeter = submeters;
    
        submeterPower(index) = GetPortTotalPower(submeter); 
        others = others - submeterPower(index); 
        index = index+1; 
    end
    
    labels = house{1}{4};
    labels = {labels{:,:}, 'Others'};
    dataset = [submeterPower others];
    prc = round((dataset ./ sum(dataset))*100); 
    explode = zeros(1,length(labels)); 
    for i = 1:length(labels)
        labels{i} = [labels{i} ': ' num2str(prc(i)) '%'];
%         if(prc(i)<6)
%             explode(i) = 1;
%         end
    end
    
    subplot(1,length(houses),m)
    pie(dataset, explode, labels); 
    title(['House ' num2str(house{1}{1})]);
    
    m = m+1; 
end