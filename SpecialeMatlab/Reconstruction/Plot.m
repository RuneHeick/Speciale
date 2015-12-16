clear all
load('ColRes');

for  known = 1:14
    
   GapFixes = zeros(6,size(CollectedResult,1));
    
   for GapIndex = 1:size(CollectedResult,1)
    
       gapSize = CollectedResult{GapIndex,1};  
       gapInfo = CollectedResult{GapIndex,2};  
       
       knownsizeHalf = gapInfo{known,1}
       recinfo = gapInfo{known,2}
       
       methodData = zeros(1,5); 
       for senario = 1:size(recinfo,2)
           
           for method = 2:6
                methodData(method-1) = methodData(method-1)+ recinfo{1,senario}{1,method}(2);
               
           end
       end
       methodData = methodData ./ size(recinfo,2);
       
       GapFixes(1,GapIndex) = gapSize;
       GapFixes(2:6,GapIndex) = methodData;
       
   end
   
   GapFixes(2:6,1:4)
   semilogy(GapFixes(1,:), GapFixes([2 4 5 6],:))
   names = {'PGGapFixer', 'EnvGapFixer', 'EMDGapFixer', 'SSAGapFixer'};
   legend(names, 'Location','best');
   %ylim([1e4 1e11]);
   title(['Known: ' num2str(knownsizeHalf)]);
   pause()
end