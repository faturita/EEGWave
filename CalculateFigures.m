clear all
close all
globalrandomdelay=false;
globalrandomamplitude=false;
run('PerformanceBenchmark.m');
save('performances2.mat');
clear all
close all
globalrandomdelay=true;
globalrandomamplitude=false;
run('PerformanceBenchmark.m');
save('performancerandomdelay2.mat');
clear all
close all
globalrandomdelay=false;
globalrandomamplitude=true;
run('PerformanceBenchmark.m');
save('performancerandomamplitude2.mat');

%%
clear all
close all
load('performances2.mat');
run('PlotPerformanceFigure.m');
load('performancerandomdelay2.mat');
run('PlotPerformanceFigure.m');
load('performancerandomamplitude2.mat');
run('PlotPerformanceFigure.m');