function [ x_gap ] = PGGapFixer( x_gap, i_gapStart, gapLength )
%PGGAPFIXER Summary of this function goes here
%   Detailed explanation goes here

traindelta = 50;

i_trainLeft = (i_gapStart>traindelta)*(i_gapStart-traindelta) + (i_gapStart<=traindelta);
i_trainRigth = (length(x_gap)- (i_gapStart+gapLength) > traindelta)*(i_gapStart+gapLength+traindelta) + (length(x_gap)- (i_gapStart+gapLength) <= traindelta)*length(x_gap);

i_gapZoomStart = i_gapStart - i_trainLeft +1;
x_gapZoom = x_gap(i_trainLeft:i_trainRigth);

D = diag([ones(i_gapZoomStart-1,1) ; zeros(gapLength,1) ; ones(size(x_gapZoom,1)-(i_gapZoomStart-1)-gapLength,1)]);

y = D*x_gapZoom; 

priorFFT = abs(fft(x_gap(i_trainLeft:i_gapStart-1)));
[pks1,locs1] = findpeaks(priorFFT(1:end/2));
afterFFT = fft(x_gap(i_gapStart+gapLength:i_trainRigth));
[pks2,locs2] = findpeaks(priorFFT(1:end/2));

maxF = max(max(locs1),max(locs2));

M = maxF*2+2;
gamma = [ones(M,1) ; zeros(size(x_gapZoom,1)-2*M,1) ; ones(M,1)];
GAMMA = diag(gamma);

F = dftmtx(size(x_gapZoom,1)); 
B = inv(F)*GAMMA*F; 
I = eye(size(x_gapZoom,1));


x_hat = y;
x_old = y; 

delta = 0.000001; 

for i = 1:25000
    
    x_hat = y + (I-D)*B*x_hat;

    if(sum(abs(x_old-x_hat))/size(x_hat,1) < delta)
        break;  
    end
    
    x_old = x_hat; 
    
end

x_gap(i_trainLeft:i_trainRigth) = real(x_hat);


end

