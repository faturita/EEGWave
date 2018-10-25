%CalculateERPFigures
clear all
close all
globalsubjectrange=[21,24,25,26];
globalrandomdelay=false;
globalrandomamplitude=false;
run('RunERPProcess.m');
save('1-1.mat');
clear all
close all
globalsubjectrange=[21,24,25,26];
globalrandomdelay=true;
globalrandomamplitude=false;
run('RunERPProcess.m');
save('1-2.mat');
clear all
close all
globalsubjectrange=[21,24,25,26];
globalrandomdelay=false;
globalrandomamplitude=true;
run('RunERPProcess.m');
save('1-3.mat');

%%
clear all
close all
load('1-1.mat');
run('PlotERPProcess.m');
load('1-2.mat');
run('PlotERPProcess.m');
load('1-3.mat');
run('PlotERPProcess.m');