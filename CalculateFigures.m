clear all
close all
globalrandomdelay=false;
globalrandomamplitude=false;
run('PerformanceBenchmark.m');
clear all
close all
globalrandomdelay=true;
globalrandomamplitude=false;
run('PerformanceBenchmark.m');
clear all
close all
globalrandomdelay=false;
globalrandomamplitude=true;
run('PerformanceBenchmark.m');

