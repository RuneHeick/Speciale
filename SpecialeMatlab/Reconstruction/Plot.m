clear all
load('ColRes');
plotindex = 1; 
figure
for  known = 1:size(CollectedResult{1,2},1)
    
   GapFixes = zeros(6,size(CollectedResult,1));
    
   for GapIndex = 1:size(CollectedResult,1)
    
       gapSize = CollectedResult{GapIndex,1};  
       gapInfo = CollectedResult{GapIndex,2};  
       
       knownsizeHalf = gapInfo{known,1}
       recinfo = gapInfo{known,2}
       
       methodData = zeros(size(recinfo,1),5); 
       for senario = 1:size(recinfo,1)
           
                senarioData = recinfo{senario,1};
                methodData(senario, :) = senarioData(:,3)';
       end
             
       
       GapFixes(1,GapIndex) = gapSize;
       GapFixes(2:6,GapIndex) = mean(methodData,1);
       
   end
   
   subplot(1,size(CollectedResult{1,2},1),plotindex)
   
   GapFixes(find(GapFixes(:,1)<0.1),1) = 0.1;
   
   GapFixes(find(GapFixes(:,:)==inf)) = 1e100;
  
   
   semilogy(GapFixes(1,:), GapFixes([2 3 4 5 6],:))
   
   ylim([1e5 1e25]); %1
   %ylim([1e18 1e28]); %2
   %ylim([1e4 1e12]); %1
   xlim([1 50]);
   title(['Known: ' num2str(knownsizeHalf)]);
   
   if(known == 1)
       xlabel('Gap size [missing samples]'); 
       ylabel('Meen square error');
   
       names = {'PGGapFixer', 'WienerGapFixer' ,'EnvGapFixer', 'EMDGapFixer', 'SSAGapFixer'};
       legend(names, 'Location','best');
   end
   
   plotindex = plotindex+1; 
   
end

   