%CalculateERPFigures
clear all
close all
globalsubjectrange=[3,4,6,7];
globalrandomdelay=false;
globalrandomamplitude=false;
run('RunERPProcess.m');
save('2-1.mat');
clear all
close all
globalsubjectrange=[3,4,6,7];
globalrandomdelay=true;
globalrandomamplitude=false;
run('RunERPProcess.m');
save('2-2.mat');
clear all
close all
globalsubjectrange=[3,4,6,7];
globalrandomdelay=false;
globalrandomamplitude=true;
run('RunERPProcess.m');
save('2-3.mat');

%%
clear all
close all
load('2-1.mat');
run('PlotERPProcess.m');
load('2-2.mat');
run('PlotERPProcess.m');
load('2-3.mat');
run('PlotERPProcess.m');