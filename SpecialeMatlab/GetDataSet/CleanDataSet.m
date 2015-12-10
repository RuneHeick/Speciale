function [ cleanData, errors ] = CleanDataSet( sData )

Sdelay = sData{2:end,1}-sData{1:end-1,1}; 
smedian = median(Sdelay); 

%Main meter data
[x, i] = unique(sData{:,1});
y = sData{i,2};
n = min(x):smedian:max(x);
vqSub = interp1(x,y,n);

%% Find error area 
maxAllowedDelay = smedian*1.2;

ErrorI = find(Sdelay>maxAllowedDelay);
ErrorTimes = [sData{ErrorI,1} sData{ErrorI+1,1}, Sdelay(ErrorI)];

%% Remove errors 
index = 1;
errors = [];
for i = 1: size(n,2)

   if( n(i) > ErrorTimes(index,1) && n(i) < ErrorTimes(index,2))
       vqSub(i) = nan; 
       errors = [errors i];
   end
   
   if(n(i) > ErrorTimes(index,2))
      index = index +1 ;
      if index > size(ErrorTimes,1)
         break; 
      end
   end
    
end

cleanData = vqSub;
end

