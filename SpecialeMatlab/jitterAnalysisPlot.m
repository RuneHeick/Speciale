close all;
n = 1:50; 

base = sin(n*0.1)
jitter = base+0.5*(0.5-rand(size(n)));



plot(jitter,'k')
hold on;


X=[n,fliplr(n)];                %#create continuous x value array for plotting
Y=[jitter,fliplr(base)];              %#create y values for out and then back
fill(X,Y,'r');  

plot(base,'b');
fig = gca;
fig.XTick = [];
fig.XTickLabel  = [];
fig.YTick = [];
fig.YTickLabel  = [];

legend({'Original Signal','Jitter Power','Mean Signal'})