

Fs = 8000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.05;             % seconds
n = (-(StopTime-dt)/2:dt:(StopTime-dt)/2)';     % seconds

Fc = 1000;                     % hertz
x = sin(2*pi*Fc*n); 

plot(x)

%% Creating the Gap Area 

gapSize = 20; 
gapStart = 200;
traindelta = 100;

i_trainLeft = (gapStart>traindelta)*(gapStart-traindelta) + (gapStart<=traindelta);
x_priorGap = x(i_trainLeft:gapStart-1); 

%% Start 

p_t = [zeros(gapSize,1); ones(size(x_priorGap)); zeros(gapSize,1) ]; 
g = [zeros(gapSize,1); x_priorGap ; zeros(gapSize,1)]; 

figure(1)
subplot(2,1,1)
plot(abs(fft(x(i_trainLeft:gapStart+gapSize)))); 

G_0 = fft(g); 

for i = 1:1000
    
binSize = floor((2000 / (Fs / length(g)) ));
p_s = ones(size(G_0));
p_s(binSize:end-binSize) = 0 ;

F_1 = G_0 .*p_s;


subplot(2,1,2)
plot(abs(F_1));

f_1 = abs(ifft(F_1, size(g,1)));
 

g = f_1 + ( g - f_1).*p_t;

G_0 = fft(g); 
end

figure(2)
subplot(2,1,1)
plot(x(i_trainLeft:gapStart+gapSize));
subplot(2,1,2)
plot(g);
