% figure;
% set(0, 'DefaultAxesFontSize',15);
% subplot(2,5,1);plot(globalrepts1,'LineWidth',2);title('MP 1');axis([0 10 0 1.05]);
% subplot(2,5,2);plot(globalrepts2,'LineWidth',2);title('MP 2');axis([0 10 0 1.05]);
% subplot(2,5,3);plot(globalrepts3,'LineWidth',2);title('SIFT');axis([0 10 0 1.05]);
% subplot(2,5,4);plot(globalrepts6,'LineWidth',2);title('PE');axis([0 10 0 1.05]);
% subplot(2,5,5);plot(globalrepts7,'LineWidth',2);title('SHCC');axis([0 10 0 1.05]);
% subplot(2,5,6);plot(globalrepts9,'LineWidth',2);title('RS');axis([0 10 0 1.05]);
% subplot(2,5,7);plot(globalrepts10,'LineWidth',2);title('RS m-c');axis([0 10 0 1.05]);
% subplot(2,5,8);plot(globalrepts8,'LineWidth',2);title('NN s-c');axis([0 10 0 1.05]);
% subplot(2,5,9);plot(globalrepts5,'LineWidth',2);title('NN m-c');axis([0 10 0 1.05]);
% subplot(2,5,10);plot(globalrepts4,'LineWidth',2);title('SVM m-c');axis([0 10 0 1.05]);
% axis([0 10 0 1.05]);
% %ylabel('Performance')
% %set(hx,'fontSize',40);
% %set(hy,'fontSize',40);
% set(gcf, 'Position', [1, 1, 730, 329])


f=figure;
set(0, 'DefaultAxesFontSize',15);
subplot(2,3,1);plot(globalrepts1,'LineWidth',2);title('MP 1');axis([0 10 0 1.05]);
subplot(2,3,2);plot(globalrepts2,'LineWidth',2);title('MP 2');axis([0 10 0 1.05]);
subplot(2,3,3);plot(globalrepts3,'LineWidth',2);title('HIST');axis([0 10 0 1.05]);
subplot(2,3,4);plot(globalrepts6,'LineWidth',2);title('PE');axis([0 10 0 1.05]);
subplot(2,3,5);plot(globalrepts7,'LineWidth',2);title('SHCC');axis([0 10 0 1.05]);
subplot(2,3,6);plot(globalrepts4,'LineWidth',2);title('SVM');axis([0 10 0 1.05]);
axis([0 10 0 1.05]);
%ylabel('Performance')
%set(hx,'fontSize',40);
%set(hy,'fontSize',40);
set(gcf, 'Position', [1, 1, 730, 329])
%print(f,'../../Documents/Research/Thesis/images/CrossPerformanceTestAmplitude','-deps')