clear all
close all
load('GapData');

levels = 15; 

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

subplot(1,2,1)
bar(hisD)
xlabel('Gap size');
ylabel('Quantity');
xlim([0, 16]);

fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 15 3];
fig.PaperPositionMode = 'manual';

print(fig,'-dpng','GapInfo')