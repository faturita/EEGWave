clear all
close all
globalrandomdelay=false;
globalrandomamplitude=false;
run('DoPerformanceBenchmark.m');
save('1-1c.mat');
clear all
close all
globalrandomdelay=true;
globalrandomamplitude=false;
run('DoPerformanceBenchmark.m');
save('1-2c.mat');
clear all
close all
globalrandomdelay=false;
globalrandomamplitude=true;
run('DoPerformanceBenchmark.m');
save('1-3c.mat');

%%
clear all
close all
load('1-1c.mat');
channels={ 'Fz'  ,  'Cz',    'P3' ,   'Pz'  ,  'P4'  , 'PO7'   , 'PO8',  'Oz'};
subjectRange=globalsubjectrange;
run('PlotERPProcess.m');
load('1-2c.mat');
channels={ 'Fz'  ,  'Cz',    'P3' ,   'Pz'  ,  'P4'  , 'PO7'   , 'PO8',  'Oz'};
subjectRange=globalsubjectrange;
run('PlotERPProcess.m');
load('1-3c.mat');
channels={ 'Fz'  ,  'Cz',    'P3' ,   'Pz'  ,  'P4'  , 'PO7'   , 'PO8',  'Oz'};
subjectRange=globalsubjectrange;
run('PlotERPProcess.m');