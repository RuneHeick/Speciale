%% Time specifications:
Fs = 8000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.25;             % seconds
t = (0:dt:StopTime-dt)';     % seconds
%% Sine wave:
Fc = 50;                     % hertz
data = cos(2*pi*Fc*t)'+10;
close all

%data = 1:2000; 

error = CreateErrorSignal(data,0.8);

fixed = GapFillingSignal(error,'Env');

plot(error); 
hold on 
plot(fixed); 