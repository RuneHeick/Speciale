
Fs = 8000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.05;             % seconds
n = (-(StopTime-dt)/2:dt:(StopTime-dt)/2)';     % seconds

Fc = 100;                     % hertz
x = sin(2*pi*Fc*n)+sin(2*pi*4*Fc*n);
% x = (testdata(1431:1642))';
% n = (1:length(x))';

gapStart = 123;
gapSize = 10; 


%% EMP Gap Splitting 


Left = [x(1:gapStart-1) , n(1:gapStart-1)]; 
Rigth = [ x(gapStart+gapSize:end) , n(gapStart+gapSize:end)];
signal = [Left ; Rigth];

infs = Modemd(Left, Rigth);
%infs = emd(signal);


figure
for i = 1:size(infs,1)
    
   subplot(size(infs,1)+1,1,i);
   fig = [ infs(i,1:length(Left)) zeros(1,gapSize) infs(i,length(Left)+1:end) ];
   plot(n, fig);
    
end

subplot(size(infs,1)+1,1,size(infs,1)+1);
plot([ signal(1:length(Left),1) ; zeros(gapSize,1) ; signal(length(Left)+1:end,1) ])