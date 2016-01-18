clear all
load('ColRes');
plotindex = 1; 
hold off
for  known = 1:size(CollectedResult{1,2},1)
    
   GapFixes = zeros(7,size(CollectedResult,1));
    
   for GapIndex = 1:size(CollectedResult,1)
    
       gapSize = CollectedResult{GapIndex,1};  
       gapInfo = CollectedResult{GapIndex,2};  
       
       knownsizeHalf = gapInfo{known,1}
       recinfo = gapInfo{known,2}
       
       methodData = zeros(size(recinfo,1),6); 
       for senario = 1:size(recinfo,1)
           
                senarioData = recinfo{senario,1};
                methodData(senario, :) = senarioData(:,3)';
       end
             
       
       GapFixes(1,GapIndex) = gapSize;
       GapFixes(2:7,GapIndex) = mean(methodData,1);
       
   end
   
   subplot(1,size(CollectedResult{1,2},1),plotindex)
   
   GapFixes(find(GapFixes(:,1)<0.1),1) = 0.1;
   
   GapFixes(find(GapFixes(:,:)==inf)) = 1e100;
  
   
   semilogy(GapFixes(1,:), GapFixes([2 3 4 5 6 7],:))
   
   ylim([0 1e2]); %1
   %ylim([0 1e1]); %2
%    ylim([1e4 1e12]); %1
   xlim([1 25]);
   title(['Known: ' num2str(knownsizeHalf)]);
   
   if(known == 1)
       xlabel('Gap size [missing samples]'); 
       ylabel('Meen square error');
        %'WienerGapFixer' missing 
       names = {'P-G','Wiener' ,'Envelope', 'EMD', 'SSA', 'Linear'};
       legend(names, 'Location','best');
   end
   
   plotindex = plotindex+1; 
   
end

   