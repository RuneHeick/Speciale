close all; 
%clear all; 

Fs = 8000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.05;             % seconds
n = (-(StopTime-dt)/2:dt:(StopTime-dt)/2)';     % seconds

Fc = 100;                     % hertz
x = sin(2*pi*Fc*n)+sin(2*pi*4*Fc*n);
% x = (testdata(1500:1800))';
% n = (1:length(x))';

gapStart = 150;
gapSize = 10; 

subplot(3,1,1)
plot(n,x)
hold on
plot(n(gapStart:gapStart+gapSize), x(gapStart:gapStart+gapSize));
axis([min(n) max(n) min(x) max(x)])

x_fixed1 = PGGapFixer(x,gapStart,gapSize);
subplot(3,1,2)
plot(n, x_fixed1);
hold on
plot(n(gapStart:gapStart+gapSize), x_fixed1(gapStart:gapStart+gapSize));
title('PGGapFixer');
axis([min(n) max(n) min(x_fixed1) max(x_fixed1)])

x_fixed2 = WienerGapFixer(x,gapStart,gapSize);
subplot(3,1,3)
plot(n, x_fixed2);
hold on
plot(n(gapStart:gapStart+gapSize), x_fixed2(gapStart:gapStart+gapSize));
title('WienerGapFixer');
axis([min(n) max(n) min(x_fixed2) max(x_fixed2)])