
% EMD:  Emprical mode decomposition
%
% imf = emd(x)
%
% x   - input signal (must be a column vector)
%
% This version will calculate all the imf's (longer)
%
% imf - Matrix of intrinsic mode functions (each as a row)
%       with residual in last row.
%
% See:  Huang et al, Royal Society Proceedings on Math, Physical, 
%       and Engineering Sciences, vol. 454, no. 1971, pp. 903-995, 
%       8 March 1998
%
% Author: Ivan Magrin-Chagnolleau  <ivan@ieee.org>
% 

function imf = Modemd(x, gapStart, gapSize)

n = (1:length(x))'; 
left = [x(1:gapStart-1) , n(1:gapStart-1)]; 
rigth = [ x(gapStart+gapSize:end) , n(gapStart+gapSize:end)];
c =  [left ; rigth]'; % copy of the input signal (as a row vector) to collum vector. 
N = length(c);

%-------------------------------------------------------------------------
% loop to decompose the input signal into successive IMF

imf = []; % Matrix which will contain the successive IMF, and the residue
I = 1;
while (1) % the stop criterion is tested at the end of the loop
   
   %-------------------------------------------------------------------------
   % inner loop to find each imf
   
   h = c(1, :); % at the beginning of the sifting process, h is the signal
   k=1;
   SD = 1; % Standard deviation which will be used to stop the sifting process

   
   while SD > 0.3 && k <= 100/I
      % while the standard deviation is higher than 0.3 (typical value)
      mins = []; 
      maxes = [];
      
      
      [mins(2,:), mins(1,:)] = findpeaks(h*-1); 
       mins(2,:) = mins(2,:)*-1; 
      [maxes(2,:), maxes(1,:)] = findpeaks(h); 
      
      
      
      try
      % stop criterion of the algo.
      if (abs(max(maxes(2,:)))>10^6 && abs(min(mins(2,:)))>10^6)
          h = [ c(1,1:length(left)) zeros(1,gapSize) c(1,length(left)+1:end) ];
          ipoint = [ gapStart-2 gapStart-1 gapStart+gapSize gapStart+gapSize+1]; 
          vpoint = h(ipoint);
          h(gapStart:gapStart+gapSize) = spline(ipoint,vpoint,gapStart:gapStart+gapSize);
          imf = [imf;  h];
          return
      end
      catch
          h = [ c(1,1:length(left)) zeros(1,gapSize) c(1,length(left)+1:end) ];
          ipoint = [ gapStart-2 gapStart-1 gapStart+gapSize gapStart+gapSize+1]; 
          vpoint = h(ipoint);
          h(gapStart:gapStart+gapSize) = spline(ipoint,vpoint,gapStart:gapStart+gapSize);
          imf = [imf;  h];
        return
      end
      
      %Max
      Lindex = find(maxes(1,:)<length(left)); 
      Rindex = find(maxes(1,:)>length(left)+1);
      
      if(isempty(Lindex) || isempty(Rindex))
          maxes = [ [1; h(1)] maxes [N; h(N)]];
      else
        maxesL = [[1 ; max(h(1),maxes(2,1))] maxes(:,Lindex) [length(left) ; max(h(length(left)),maxes(2,Lindex(end)))] ];
        maxesR = [[length(left)+1 ; max(h(length(left)+1),maxes(2,Rindex(1)))]  maxes(:,Rindex) [N ; max(h(N),maxes(2,Rindex(end))) ] ];
     	maxes = [ maxesL maxesR];
      end 
      
      %Min 
      Lindex = find(mins(1,:)<length(left)); 
      Rindex = find(mins(1,:)>length(left)+1);
      if(isempty(Lindex) || isempty(Rindex))
          mins = [ [1; h(1)] mins [N; h(N)]];
      else
          minsL = [[1 ; min(h(1),mins(2,1))] mins(:,Lindex) [length(left) ; min(h(length(left)),mins(2,Lindex(end)))]];
          minsR = [[length(left)+1 ; min(h(length(left)+1),mins(2,Rindex(1)))]  mins(:,Rindex) [N ; min(h(N),mins(2,Rindex(end))) ] ];
          mins = [ minsL minsR];
      end
           
      %-------------------------------------------------------------------------
      % spline interpolate to get max and min envelopes; form imf
      maxenv = spline(c(2,maxes(1,:)),maxes(2,:),n);
      minenv = spline(c(2,mins(1,:)), mins(2,:),n);
          
      
      m = ([maxenv(1:gapStart-1) ; maxenv(gapStart+gapSize:end)] + [minenv(1:gapStart-1) ; minenv(gapStart+gapSize:end)])'/2; % mean of max and min enveloppes
      prevh = h; % copy of the previous value of h before modifying it
      h = h - m; % substract mean to h
      
      % calculate standard deviation
      eps = 0.0000001; % to avoid zero values
      SD = sum ( ((prevh - h).^2) ./ (prevh.^2 + eps) );
      k =k+1;
   end
   
   h_rep = [ h(1:length(left)) zeros(1,gapSize) h(length(left)+1:end) ];
   figure(8)
   scatter(c(2,maxes(1,:)),maxes(2,:))
   hold on
   scatter(c(2,mins(1,:)),mins(2,:))
   plot(h_rep)
   plot(maxenv)
   plot(minenv)
   hold off
   
   
   
   h_rep = imfRec2( h_rep, gapStart, gapSize, minenv, maxenv);
   
   imf = [imf; h_rep]; % store the extracted IMF in the matrix imf
   % if size(maxmin,2)<2, then h is the residue
   I = I+1;
      
   c(1,:) = c(1,:) - h; % substract the extracted IMF from the signal
   
   % stop criterion of the algo.
   if (size(maxes,2)+size(mins,2)) < 2 || size(imf,1)>10
      h = [ c(1,1:length(left)) zeros(1,gapSize) c(1,length(left)+1:end) ];
      ipoint = [ gapStart-2 gapStart-1 gapStart+gapSize gapStart+gapSize+1]; 
      vpoint = h(ipoint);
      h(gapStart:gapStart+gapSize) = spline(ipoint,vpoint,gapStart:gapStart+gapSize);
      imf = [imf;  h];
      break
   end
   
end

return