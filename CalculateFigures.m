clear all
close all
globalrandomdelay=false;
globalrandomamplitude=false;
run('PerformanceBenchmark.m');
save('performancesvm.mat');
clear all
close all
globalrandomdelay=true;
globalrandomamplitude=false;
run('PerformanceBenchmark.m');
save('performancerandomdelaysvm.mat');
clear all
close all
globalrandomdelay=false;
globalrandomamplitude=true;
run('PerformanceBenchmark.m');
save('performancerandomamplitudesvm.mat');

%%
clear all
close all
load('performancesvm.mat');
run('PlotPerformanceFigure.m');
load('performancerandomdelaysvm.mat');
run('PlotPerformanceFigure.m');
load('performancerandomamplitudesvm.mat');
run('PlotPerformanceFigure.m');