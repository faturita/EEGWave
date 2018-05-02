clear all
close all
globalrandomdelay=false;
globalrandomamplitude=false;
run('PerformanceBenchmark.m');
save('performance.mat');
clear all
close all
globalrandomdelay=true;
globalrandomamplitude=false;
run('PerformanceBenchmark.m');
save('performancerandomdelay.mat');
clear all
close all
globalrandomdelay=false;
globalrandomamplitude=true;
run('PerformanceBenchmark.m');
save('performancerandomamplitude.mat');

