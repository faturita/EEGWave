%%
globalrepts1=[];
globalrepts2=[];
globalrepts3=[];
globalrepts4=[];
globalrepts5=[];
globalrepts6=[];
globalrepts7=[];
globalrepts8=[];
globalrepts9=[];
globalrepts10=[];
globalsignalgain=2.2;
globalsignalsize=64;
for globalrepetitions=1:10
    
    % NNET
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=5;
    run('ERPProcess.m')
    globalrepts1 = [globalrepts1 totals(:,6)];  
    globalchannel1 = totals(:,5);
    
    globalappyzscore=false;
    globalclassifier=11;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalrepts2 = [globalrepts2 totals(:,6)];  
    globalchannel2 = totals(:,5);
    
    % HGO
    globalappyzscore=true;
    globalclassifier=6;
    globalfeaturetype=1;
    run('ERPProcess.m')
    globalrepts3 = [globalrepts3 totals(:,6)];
    globalchannel3 = totals(:,5);
    
    globalappyzscore=false;
    globalclassifier=4;
    globalfeaturetype=2;
    run('ERPProcess.m')
    globalrepts4 = [globalrepts4 totals(:,6)];
    globalchannel4 = totals(:,5);
     
    globalappyzscore=false;
    globalclassifier=1;
    globalfeaturetype=2;
    run('ERPProcess.m')
    globalrepts5 = [globalrepts5 totals(:,6)];
    globalchannel5 = totals(:,5);
    
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=6;
    run('ERPProcess.m')
    globalrepts6 = [globalrepts6 totals(:,6)];  
    globalchannel6 = totals(:,5);
    
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=7;
    run('ERPProcess.m')
    globalrepts7 = [globalrepts7 totals(:,6)]; 
    globalchannel7 = totals(:,5);
    
    globalappyzscore=false;
    globalclassifier=1;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalrepts8 = [globalrepts8 totals(:,6)]; 
    globalchannel8 = totals(:,5);
    
    % Raw signal single channel
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalrepts9 = [globalrepts9 totals(:,6)]; 
    globalchannel9 = totals(:,5);
    
    % Raw signal multi channel
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=2;
    run('ERPProcess.m')
    globalrepts10 = [globalrepts10 totals(:,6)]; 
    globalchannel10 = totals(:,5);
end
    
%%
figure;
set(0, 'DefaultAxesFontSize',15);
subplot(2,5,1);plot(globalrepts1,'LineWidth',2);title('MP 1');axis([0 10 0 1.05]);
subplot(2,5,2);plot(globalrepts2,'LineWidth',2);title('MP 2');axis([0 10 0 1.05]);
subplot(2,5,3);plot(globalrepts3,'LineWidth',2);title('HGO');axis([0 10 0 1.05]);
subplot(2,5,4);plot(globalrepts6,'LineWidth',2);title('PE');axis([0 10 0 1.05]);
subplot(2,5,5);plot(globalrepts7,'LineWidth',2);title('SHCC');axis([0 10 0 1.05]);
subplot(2,5,6);plot(globalrepts9,'LineWidth',2);title('RS');axis([0 10 0 1.05]);
subplot(2,5,7);plot(globalrepts10,'LineWidth',2);title('RS m-c');axis([0 10 0 1.05]);
subplot(2,5,8);plot(globalrepts8,'LineWidth',2);title('NN s-c');axis([0 10 0 1.05]);
subplot(2,5,9);plot(globalrepts5,'LineWidth',2);title('NN m-c');axis([0 10 0 1.05]);
subplot(2,5,10);plot(globalrepts4,'LineWidth',2);title('SVM m-c');axis([0 10 0 1.05]);
axis([0 10 0 1.05]);
%ylabel('Performance')
%set(hx,'fontSize',40);
%set(hy,'fontSize',40);
set(gcf, 'Position', [1, 1, 730, 329])



