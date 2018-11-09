clear all
close all
globalrandomdelay=false;
globalrandomamplitude=false;
run('BCICompetitionPerformanceBenchmark.m');
save('performancesbcicompetition.mat');

%%
figure;
set(0, 'DefaultAxesFontSize',15);

subplot(2,3,1);PlotOneSubjectOneMethod(channels,subject,globalrepts1);title('MP 1');axis([0 15 0 1.05]);set(gca, 'XTickLabel', []);set(gca, 'XTickLabel', []);
subplot(2,3,2);PlotOneSubjectOneMethod(channels,subject,globalrepts2);title('MP 2');axis([0 15 0 1.05]);set(gca, 'YTickLabel', []);set(gca, 'XTickLabel', []);
subplot(2,3,3);PlotOneSubjectOneMethod(channels,subject,globalrepts3);title('SIFT');axis([0 15 0 1.05]);set(gca, 'YTickLabel', []); set(gca, 'XTickLabel', []);
subplot(2,3,4);PlotOneSubjectOneMethod(channels,subject,globalrepts6);title('PE');axis([0 15 0 1.05]);
subplot(2,3,5);PlotOneSubjectOneMethod(channels,subject,globalrepts7);title('SHCC');axis([0 15 0 1.05]);set(gca, 'YTickLabel', []);
subplot(2,3,6);PlotOneSubjectOneMethod(channels,subject,globalrepts4);title('SVM');axis([0 15 0 1.05]);set(gca, 'YTickLabel', []);

axis([0 15 0 1.05]);
%ylabel('Performance')
%set(hx,'fontSize',40);
%set(hy,'fontSize',40);
set(gcf, 'Position', [1, 1, 730, 329])


ylabel('Performance','visible','on');
xlabel('Intensifications','visible','on');