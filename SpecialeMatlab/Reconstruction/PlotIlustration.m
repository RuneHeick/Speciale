clear all, close all ; 
load('DataSnips');

set = data{1,1};
set = set(120:160);
n = 1:length(set); 

x = [n' set']



gapset = x;
gapset(20:25,2) = nan; 

gapset2 = gapset;
gapset2([1:17 28:end],2) = nan; 

subplot(3,1,1)
plot(x(:,1), x(:,2),'r');
hold on
plot(gapset(:,1), gapset(:,2))
xlim([0 41]);
ylim([0 2e5]);
title('Original');
fig = gca; 
fig.XTick = [];
fig.XTickLabel  = [];
fig.YTick = [];
fig.YTickLabel  = [];


subplot(3,1,2)
plot(gapset2(:,1), gapset2(:,2))
xlim([0 41]);
ylim([0 2e5]);
title('Known: 3');
fig = gca;
fig.XTick = [];
fig.XTickLabel  = [];
fig.YTick = [];
fig.YTickLabel  = [];
ylabel('Power Value');


gapset3 = gapset;
gapset3([1:17-12 28+12:end],2) = nan;
subplot(3,1,3)
plot(gapset3(:,1), gapset3(:,2))
title('Known: 15');
xlim([0 41]);
ylim([0 2e5]);
fig = gca;
fig.XTick = [];
fig.XTickLabel  = [];
fig.YTick = [];
fig.YTickLabel  = [];
xlabel('Time')