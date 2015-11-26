
clear all; 

Fs = 8000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.25;             % seconds
n = (0:dt:StopTime-dt)';     % seconds

Fc = 20;                     % hertz
basesignal = sin(2*pi*Fc*n)+sin(2*pi*5*Fc*n); 

plot(basesignal)

bins = fft(basesignal); 
Fsbins = -((size(bins,1))/2) * Fs / size(basesignal,1): Fs / size(basesignal,1) : (size(bins,1)/2-1) * Fs / size(basesignal,1);

fftsig = fftshift(fft(basesignal)); 
subplot(2,1,1)
plot(Fsbins,abs(fftsig)); 
subplot(2,1,2)
plot(unwrap(angle(fftsig)));

phi = 0.01; 
t = (phi:dt:(StopTime-dt)+phi)';     % seconds

trainL = 200;
[a,g] = lpc(basesignal,trainL);

predictionLength = size(basesignal,1);

result = zeros(1,predictionLength); 
result(1:trainL) = basesignal(1:trainL);
data(1:trainL) = basesignal(1:trainL);

est_x2 = filter([0 -a(2:end)],1,basesignal);


for index = trainL+1:predictionLength
    predict = filter([0 -a(2:end)],1,[result(1:index-1) 0]);
    result(index) = predict(end); 
end
 
figure
subplot(2,1,1)
plot(result)
subplot(2,1,2)
plot(basesignal)
