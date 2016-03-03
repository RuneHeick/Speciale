% This file is part of the project NILM-Eval (https://github.com/beckel/nilm-eval).
% Licence: GPL 2.0 (http://www.gnu.org/licenses/gpl-2.0.html)
% Copyright: ETH Zurich, 2014
% Author: Romano Cicchetti

warning off MATLAB:dispatcher:nameConflict

% some conflict with 'legend' plotting function :(
% addpath(genpath('lib/bnt')); 
rmpath(genpath('lib/lightspeed'));
rmpath(genpath('lib/proxTV-1.0'));
rmpath(genpath('lib/spectralClustering'));
rmpath(genpath('lib/TVDIP'));
rmpath(genpath('lib/YAMLMatlab_0.4.3'));
rmpath(genpath('lib/bnt'));
rmpath(genpath('plot'));
rmpath('projects/');
rmpath('projects/buildsys/');
rmpath('projects/buildsys/images/');
