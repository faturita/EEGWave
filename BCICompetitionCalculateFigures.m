clear all
close all
globalrandomdelay=false;
globalrandomamplitude=false;
run('BCICompetitionPerformanceBenchmark.m');
save('performancesbcicompetition.mat');

figure;
set(0, 'DefaultAxesFontSize',15);
subplot(2,3,1);plot(globalrepts1,'LineWidth',2);title('MP 1');axis([0 15 0 1.05]);
subplot(2,3,2);plot(globalrepts2,'LineWidth',2);title('MP 2');axis([0 15 0 1.05]);
subplot(2,3,3);plot(globalrepts3,'LineWidth',2);title('SIFT');axis([0 15 0 1.05]);
subplot(2,3,4);plot(globalrepts6,'LineWidth',2);title('PE');axis([0 15 0 1.05]);
subplot(2,3,5);plot(globalrepts7,'LineWidth',2);title('SHCC');axis([0 15 0 1.05]);
subplot(2,3,6);plot(globalrepts4,'LineWidth',2);title('SVM');axis([0 15 0 1.05]);
axis([0 15 0 1.05]);
%ylabel('Performance')
%set(hx,'fontSize',40);
%set(hy,'fontSize',40);
set(gcf, 'Position', [1, 1, 730, 329])
