clear all
close all
load('GapData');

levels = 6; 

muSig = zeros(levels,3);
hisD = zeros(levels,3);

for i = 1:levels

  level = sum(gapPriorPost{i},2);
  level = level(level>0); 
  
  muSig(i,:) = [median(level) max(level) min(level)];
  hisD(i) = length(level);
end

fig = figure(2)
subplot(1,2,2)
semilogy(muSig(1:levels,1))
hold on 
semilogy(muSig(1:levels,2))
semilogy(muSig(1:levels,3))
hold off
legend('Median knowledge','Max knowledge','Min knowledge','Location','best' ); 
xlabel('Gap size [samples]');
ylabel('prior+post knowledge');
xlim([0, 16]);

%subplot(1,2,1)
fig = figure
bar(hisD)
xlabel('Gap size');
ylabel('Quantity');
xlim([0, 6]);

fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 2 2];
fig.PaperPositionMode = 'manual';

print(fig,'-dpng','GapInfo')