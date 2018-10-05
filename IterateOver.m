%clear all
%close all

% Parameter findings.

globalrepetitions=1;
globalsignalsize=64;
KS=10:50;
for globaliterations=1:size(KS,2)
    %run('OfflineProcessP300.m');
end
%%  Finding the right KS
globalrepts1=[];
globalchannel1=[];
globalrepts2=[];
globalchannel2=[];
globalrepts3=[];
globalchannel3=[];
globalsignalgain=2.2;
globalrandomdelay=false;
globalrandomamplitude=false;
globalrepetitions=10;

for globalks=15:40
    % SIFT
    globaldistancetype='euclidean';
    globalk=7;
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=3;
    run('ERPProcess.m')
    globalrepts1 = [globalrepts1 totals(:,6)];
    globalchannel1 = totals(:,5);
end


figure;
set(0, 'DefaultAxesFontSize',15);
subplot(1,1,1);plot(globalrepts1,'LineWidth',2);title('zscore');axis([0 15 0 1.05]);grid on;
axis([0 15 0 1.05]);
%ylabel('Performance')
%set(hx,'fontSize',40);
%set(hy,'fontSize',40);
set(gcf, 'Position', [1, 1, 730, 329])
fdfsfs

%% Checking distance function
globalrepts1=[];
globalchannel1=[];
globalrepts2=[];
globalchannel2=[];
globalrepts3=[];
globalchannel3=[];
globalsignalgain=2.2;
globalrandomdelay=false;
globalrandomamplitude=false;
for globalrepetitions=1:10
    % SIFT
    globaldistancetype='euclidean';
    globalk=7;
    globalappyzscore=true;
    globalclassifier=6;
    globalfeaturetype=1;
    run('ERPProcess.m')
    globalrepts1 = [globalrepts1 totals(:,6)];
    globalchannel1 = totals(:,5);
end

for globalrepetitions=1:10
    % SIFT
    globaldistancetype='euclidean';
    globalk=7;
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=3;
    run('ERPProcess.m')
    globalrepts2 = [globalrepts2 totals(:,6)];
    globalchannel2 = totals(:,5);
end


figure;
set(0, 'DefaultAxesFontSize',15);
subplot(1,3,1);plot(globalrepts1,'LineWidth',2);title('zscore');axis([0 10 0 1.05]);grid on;
subplot(1,3,2);plot(globalrepts2,'LineWidth',2);title('autoscale');axis([0 10 0 1.05]);grid on;
axis([0 10 0 1.05]);
%ylabel('Performance')
%set(hx,'fontSize',40);
%set(hy,'fontSize',40);
set(gcf, 'Position', [1, 1, 730, 329])

gggg
%% Checking distance function
globalrepts3=[];
globalchannel3=[];
globalsignalgain=2.2;
globalrandomdelay=false;
globalrandomamplitude=false;
for globalrepetitions=1:10
    % SIFT
    globaldistancetype='euclidean';
    globalk=7;
    globalappyzscore=true;
    globalclassifier=6;
    globalfeaturetype=1;
    run('ERPProcess.m')
    globalrepts1 = [globalrepts1 totals(:,6)];
    globalchannel1 = totals(:,5);
end

for globalrepetitions=1:10
    % SIFT
    globaldistancetype='euclidean';
    globalk=3;
    globalappyzscore=true;
    globalclassifier=6;
    globalfeaturetype=1;
    run('ERPProcess.m')
    globalrepts2 = [globalrepts2 totals(:,6)];
    globalchannel2 = totals(:,5);
end

for globalrepetitions=1:10
    % SIFT
    globaldistancetype='euclidean';
    globalk=1;
    globalappyzscore=true;
    globalclassifier=6;
    globalfeaturetype=1;
    run('ERPProcess.m')
    globalrepts3 = [globalrepts3 totals(:,6)];
    globalchannel3 = totals(:,5);
end

figure;
set(0, 'DefaultAxesFontSize',15);
subplot(1,3,1);plot(globalrepts1,'LineWidth',2);title('k=7');axis([0 10 0 1.05]);grid on;
subplot(1,3,2);plot(globalrepts2,'LineWidth',2);title('k=3');axis([0 10 0 1.05]);grid on;
subplot(1,3,3);plot(globalrepts3,'LineWidth',2);title('k=1');axis([0 10 0 1.05]);grid on;
axis([0 10 0 1.05]);
%ylabel('Performance')
%set(hx,'fontSize',40);
%set(hy,'fontSize',40);
set(gcf, 'Position', [1, 1, 730, 329])
fdsfs

%% Finding parameters for PE
globalperformances6=[];
globalsignalgain=2.2;
globalrepetitions=10;
globalrandomdelay=false;
globalrandomamplitude=false;
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
globalparams6=[];
for globalm=2:8
    for globalwindowsize=globalm:5:globalsignalsize-globalm
    % PE  m=2, windowsize=12 achives better performance.
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=6;
    run('ERPProcess.m')
    globalperformances6 = [globalperformances6 totals(:,6)];
    
    globalparams6 = [globalparams6 globalwindowsize];
    globalrepts6 = [globalrepts6 totals(:,6)];  
    globalchannel6 = totals(:,5);
    end
end


for globalm=2:8
    for globalwindowsize=globalm:5:globalsignalsize-globalm
    % PE  m=2, windowsize=12 achives better performance.
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=6;
    run('ERPProcess.m')
    globalperformances6 = [globalperformances6 totals(:,6)];
    
    globalparams6 = [globalparams6 globalwindowsize];
    globalrepts6 = [globalrepts6 totals(:,6)];  
    globalchannel6 = totals(:,5);
    end
end


globalperformances1=[];
for globalsignalgain=0:40
    % MP
    globalappyzscore=false;
    globalclassifier=4;
    globalfeaturetype=5;
    run('ERPProcess.m')
    globalperformances1 = [globalperformances1 totals(:,6)];
end

globalperformances2=[];
for globalsignalgain=0:40
    % MP signal components
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalperformances2 = [globalperformances2 totals(:,6)];
end

globalperformances3=[];
for globalsignalgain=0:40
    % SIFT
    globalappyzscore=true;
    globalclassifier=6;
    globalfeaturetype=1;
    run('ERPProcess.m')
    globalperformances3 = [globalperformances3 totals(:,6)];
end

globalperformances4=[];
for globalsignalgain=0:40
    % SVM
    globalappyzscore=false;
    globalclassifier=4;
    globalfeaturetype=2;
    run('ERPProcess.m')
    globalperformances4 = [globalperformances4 totals(:,6)];
end

globalperformances5=[];
for globalsignalgain=0:40
    % NNET
    globalappyzscore=false;
    globalclassifier=1;
    globalfeaturetype=2;
    run('ERPProcess.m')
    globalperformances5 = [globalperformances5 totals(:,6)];
end

globalperformances6=[];
for globalsignalgain=0:40
    % PE
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=6;
    run('ERPProcess.m')
    globalperformances6 = [globalperformances6 totals(:,6)];
end

globalperformances7=[];
for globalsignalgain=0:40
    % SHCC
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=7;
    run('ERPProcess.m')
    globalperformances7 = [globalperformances7 totals(:,6)];
end

globalperformances8=[];
for globalsignalgain=0:40
    % NNET channel by channel
    globalappyzscore=false;
    globalclassifier=1;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalperformances8 = [globalperformances8 totals(:,6)];
end

globalperformances9=[];
for globalsignalgain=0:40
    % rraw
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalperformances9 = [globalperformances9 totals(:,6)];
end

globalperformances10=[];
for globalsignalgain=0:40
    % Raw signal single channel
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=2;
    run('ERPProcess.m')
    globalperformances10 = [globalperformances10 totals(:,6)];
end

%%
hold on
plot(0:40,globalperformances1);
plot(0:40,globalperformances2);
plot(0:40,globalperformances3);
plot(0:40,globalperformances4);
plot(0:40,globalperformances5);
plot(0:40,globalperformances6);
plot(0:40,globalperformances7);
plot(0:40,globalperformances8);
plot(0:40,globalperformances9);
%plot(0:40,globalperformances10);
axis([0 40 0 1.05]);
legend('MP ST','MP SIG ST','HGO','SVM','NN','PE','SHCC','NN Single','R m-c','R s-c');
xlabel('Drug Signal Gain');
ylabel('Performance')
%save('results.mat');
done
%%
KKS=[];
for subject=subjectRange
    performances=reshape(globalspellers(subject,:,:),[8 41]);
    figure;plot(KS,max(performances))
    
    [~,best] = max(max(performances));
    best = best(1);
    
    [ChAcc,ChNum] = max(globalspellers(subject,:,best));
    
    KKS = [KKS KS(best)];
end

KKS


