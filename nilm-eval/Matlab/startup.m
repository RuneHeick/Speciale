% This file is part of the project NILM-Eval (https://github.com/beckel/nilm-eval).
% Licence: GPL 2.0 (http://www.gnu.org/licenses/gpl-2.0.html)
% Copyright: ETH Zurich, 2014
% Author: Romano Cicchetti

warning off MATLAB:dispatcher:nameConflict

addpath(genpath('algorithms'));
addpath(genpath('config'));
addpath(genpath('data_access'));
addpath(genpath('framework'));
% some conflict with 'legend' plotting function :(
% addpath(genpath('lib/bnt')); 
addpath(genpath('lib/lightspeed'));
addpath(genpath('lib/proxTV-1.0'));
addpath(genpath('lib/spectralClustering'));
addpath(genpath('lib/TVDIP'));
addpath(genpath('lib/YAMLMatlab_0.4.3'));
addpath(genpath('lib/bnt'));
addpath(genpath('plot'));
addpath('projects/');
addpath('projects/buildsys/');
addpath('projects/buildsys/images/');
addpath(genpath('util'));
%addpath('C:/Program Files/IBM/ILOG/CPLEX_Studio_Community1263/cplex/matlab/x64_win64')

set(0,'DefaultTextFontname', 'Times New Roman');
set(0,'DefaultTextFontSize', 9);
set(0,'DefaultAxesFontName', 'Times New Roman');
set(0,'DefaultAxesFontSize', 9);


P = py.sys.path;
Ppath = [fileparts(pwd) '\Python' ] ;

if count(P,Ppath) == 0
    insert(P,int32(0),Ppath);
end