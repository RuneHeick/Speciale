close all

Fs = 8000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.1;             % seconds
n = (-(StopTime-dt)/2:dt:(StopTime-dt)/2)';     % seconds

Fc = 500;                     % hertz
x = sin(2*pi*Fc*n); 

%% Creating the Gap Area 

gapSize = 10; 
gapStart = 395;
traindelta = 100;

i_trainLeft = (gapStart>traindelta)*(gapStart-traindelta) + (gapStart<=traindelta);
i_trainRigth = (length(x)- (gapStart+gapSize) > traindelta)*(gapStart+gapSize+traindelta) + (length(x)- (gapStart+gapSize) <= traindelta)*length(x);

gapStart = gapStart - i_trainLeft;
x_gap = x(i_trainLeft:i_trainRigth);

D = diag([ones(gapStart-1,1) ; zeros(gapSize,1) ; ones(size(x_gap,1)-(gapStart-1)-gapSize,1)]);

y = D*x_gap; 
figure(3)
plot(y)

M = 55;
gamma = [ones(M,1) ; zeros(size(x_gap,1)-2*M,1) ; ones(M,1)];
GAMMA = diag(gamma);

F = dftmtx(size(x_gap,1)); 

B = inv(F)*GAMMA*F; 
I = eye(size(x_gap,1));


x_hat = y;
x_old = y; 

delta = 0.00001; 

for i = 1:25000
    
    x_hat = y + (I-D)*B*x_hat;

    if(sum(abs(x_old-x_hat))/size(x_hat,1) < delta)
        break;  
    end
    
    x_old = x_hat; 
end


figure(1)
subplot(2,1,1)
plot(abs(x_hat));
hold on 
plot(abs(y));
hold off
subplot(2,1,2)
plot(abs(x_hat-x_gap))

figure(2)
plot(abs(fft(x_hat)));

pause(0.1)




