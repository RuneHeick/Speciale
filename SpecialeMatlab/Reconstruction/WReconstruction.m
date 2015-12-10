%close all; 
%clear all; 

Fs = 8000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.05;             % seconds
n = (-(StopTime-dt)/2:dt:(StopTime-dt)/2)';     % seconds

Fc = 300;                     % hertz
% x = sin(2*pi*Fc*n);%+sin(2*pi*2*Fc*n);
x = (data(18000:32500))';
n = (1:length(x))';

gapStart = 850;
gapSize = 20; 

subplot(6,1,1)
plot(n,x)
hold on
plot(n(gapStart:gapStart+gapSize), x(gapStart:gapStart+gapSize));
axis([min(n) max(n) min(x) max(x)])
title('Original');

%%
x_fixed1 = PGGapFixer(x,gapStart,gapSize);
subplot(6,1,2)
plot(n, x_fixed1);
hold on
plot(n(gapStart:gapStart+gapSize), x_fixed1(gapStart:gapStart+gapSize));
title('PGGapFixer');
axis([min(n) max(n) min(x_fixed1) max(x_fixed1)])

%%
x_fixed2 = WienerGapFixer(x,gapStart,gapSize);
subplot(6,1,3)
plot(n, x_fixed2);
hold on
plot(n(gapStart:gapStart+gapSize), x_fixed2(gapStart:gapStart+gapSize));
title('WienerGapFixer');
axis([min(n) max(n) min(x_fixed2) max(x_fixed2)])
%%
x_fixed3 = EnvGapFixer(x,gapStart,gapSize);
subplot(6,1,4)
plot(n, x_fixed3);
hold on
plot(n(gapStart:gapStart+gapSize), x_fixed3(gapStart:gapStart+gapSize));
title('EnvelopeGapFixer');
axis([min(n) max(n) min(x_fixed3) max(x_fixed3)]);
%%
x_fixed4 = EMDGapFixer(x,gapStart,gapSize);
subplot(6,1,5)
plot(n, x_fixed4);
hold on
plot(n(gapStart:gapStart+gapSize), x_fixed4(gapStart:gapStart+gapSize));
title('EMDGapFixer');
axis([min(n) max(n) min(x_fixed4) max(x_fixed4)]);

%%

x_fixed5 = SSAGapFixer(x,gapStart,gapSize);
subplot(6,1,6)
plot(n, x_fixed5);
hold on
plot(n(gapStart:gapStart+gapSize), x_fixed5(gapStart:gapStart+gapSize));
title('SSAGapFixer');
axis([min(n) max(n) min(x_fixed5) max(x_fixed5)]);

hold off