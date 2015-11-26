close all; 
%clear all; 

Fs = 8000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.05;             % seconds
n = (-(StopTime-dt)/2:dt:(StopTime-dt)/2)';     % seconds

Fc = 100;                     % hertz
x = sin(2*pi*Fc*n)+sin(2*pi*4*Fc*n);

gapStart = 123;
gapSize = 25; 

%% EMP Gap Splitting 


Left = x(1:gapStart-1); 
Rigth = x(gapStart+gapSize:end); 

infs = emd(x);

figure
for i = 1:size(infs,1)
    
   subplot(size(infs,1)+1,1,i);
   plot(infs(i,:));
    
end

subplot(size(infs,1)+1,1,size(infs,1)+1);
plot(sum(infs,1));
hold on 
plot(x)