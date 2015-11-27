
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

function imf = Modemd(left, rigth)

c =  [left ; rigth]'; % copy of the input signal (as a row vector) to collum vector. 
N = length(c);

%-------------------------------------------------------------------------
% loop to decompose the input signal into successive IMF

imf = []; % Matrix which will contain the successive IMF, and the residue

while (1) % the stop criterion is tested at the end of the loop
   
   %-------------------------------------------------------------------------
   % inner loop to find each imf
   
   h = c(1, :); % at the beginning of the sifting process, h is the signal
   
   SD = 1; % Standard deviation which will be used to stop the sifting process
   
   while SD > 0.3
      % while the standard deviation is higher than 0.3 (typical value)
      
      % find local max/min points
      d = diff(h); % approximate derivative
      maxmin = []; % to store the optima (min and max without distinction so far)
      for i=1:N-2
         if d(i)==0                        % we are on a zero
            maxmin = [maxmin, [i ; h(i)] ];
         elseif sign(d(i))~=sign(d(i+1))   % we are straddling a zero so
            maxmin = [maxmin, [i+1 ; h(i+1)]];        % define zero as at i+1 (not i)
         end
      end
      
      if size(maxmin,2) < 2 % then it is the residue
         break
      end
      
      % divide maxmin into maxes and mins
      if maxmin(1,1)>maxmin(1,2)              % first one is a max not a min
         mins = maxmin(:,1:2:length(maxmin));
         maxes  = maxmin(:,2:2:length(maxmin));
      else                                % is the other way around
         mins = maxmin(:,2:2:length(maxmin));
         maxes  = maxmin(:,1:2:length(maxmin));
      end
          
      
      
      % make endpoints both maxes and mins
      
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
      maxenv = spline(c(2,maxes(1,:)),maxes(2,:),c(2,1:N));
      minenv = spline(c(2,mins(1,:)), mins(2,:),c(2,1:N));
          
%       figure(3)
%       scatter(c(2,maxes(1,:)),maxes(2,:))
%       hold on
%       scatter(c(2,mins(1,:)),mins(2,:))
%       plot(c(2,:),h)
%       plot(c(2,:),maxenv)
%       plot(c(2,:),minenv)
%       hold off
      
      
      m = (maxenv + minenv)/2; % mean of max and min enveloppes
      prevh = h; % copy of the previous value of h before modifying it
      h = h - m; % substract mean to h
      
      % calculate standard deviation
      eps = 0.0000001; % to avoid zero values
      SD = sum ( ((prevh - h).^2) ./ (prevh.^2 + eps) );
      
   end
   
   imf = [imf; h]; % store the extracted IMF in the matrix imf
   % if size(maxmin,2)<2, then h is the residue
   
   % stop criterion of the algo.
   if size(maxmin,2) < 2
      break
   end
   
   c(1,:) = c(1,:) - h; % substract the extracted IMF from the signal
   
end

return