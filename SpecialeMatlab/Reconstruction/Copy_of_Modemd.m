
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
   
   h = c; % at the beginning of the sifting process, h is the signal
   h_side = {h(1:length(left)) , h(length(left)+1:end)};
   SD = 1; % Standard deviation which will be used to stop the sifting process
   
   while SD > 0.3
      % while the standard deviation is higher than 0.3 (typical value)
      
      
      for j = 1:2
          
          % find local max/min points
          h_val = h_side{j}; 
          d = diff(h_val); % approximate derivative
          maxmin = []; % to store the optima (min and max without distinction so far)
          for i=1:length(d)-2
             if d(i)==0                        % we are on a zero
                maxmin = [maxmin, [ (i + (j-1)*length(left)) ; h_val(i)]];
             elseif sign(d(i))~=sign(d(i+1))   % we are straddling a zero so
                maxmin = [maxmin, [ (i+1+(j-1)*length(left)) ; h_val(i+1)]];        % define zero as at i+1 (not i)
             end
          end

          if size(maxmin,2) < 2 % then it is the residue
             break
          end

          % divide maxmin into maxes and mins
          if maxmin(1,1)>maxmin(2,1)              % first one is a max not a min
             maxes_t{j} = maxmin(:,1:2:length(maxmin));
             mins_t{j}  = maxmin(:,2:2:length(maxmin));
          else                                % is the other way around
             maxes_t{j} = maxmin(:,2:2:length(maxmin));
             mins_t{j}  = maxmin(:,1:2:length(maxmin));
          end
    
      end
      
      figure(3)
      hold on
      scatter(maxes_t{1}(1,:),maxes_t{1}(2,:))
      scatter(mins_t{1}(1,:),mins_t{1}(2,:))
      
      scatter(maxes_t{2}(1,:),maxes_t{2}(2,:))
      scatter(mins_t{2}(1,:),mins_t{2}(2,:))
      
      
      plot(h)
      hold off
      
      
      
      
      % make endpoints both maxes and mins
      leftmax = [ [1; max(maxes_t{1}(2,1), h(1))]  maxes_t{1} [length(left); max(maxes_t{1}(2,end), h(length(left)))] ];
      rigthmax = [ [length(left)+1; max(maxes_t{2}(2,1), h(length(left)+1))]  maxes_t{2} [N; max(maxes_t{2}(2,end), h(N))] ];   
      maxes = [leftmax rigthmax];
      
      leftmin = [ [1; min(mins_t{1}(2,1), h(1))]  mins_t{1} [length(left); min(mins_t{1}(2,end), h(length(left)))] ];
      rigthmin = [ [length(left)+1; min(mins_t{2}(2,1), h(length(left)+1))]  mins_t{2} [N; min(mins_t{2}(2,end), h(N))] ];   
      mins = [leftmin rigthmin];
      
      
      %-------------------------------------------------------------------------
      % spline interpolate to get max and min envelopes; form imf
      maxenv = spline(maxes(1,:),maxes(2,:),1:N);
      minenv = spline(mins(1,:), mins(2,:),1:N);
      
      figure(3)
      plot(maxenv)
      hold on
      plot(minenv)
      plot(h)
      hold off
      
      
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
   
   c = c - h; % substract the extracted IMF from the signal
   
end

return