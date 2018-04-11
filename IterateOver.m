%clear all
%close all
globalrepetitions=1;
KS=10:50;
for globaliterations=1:size(KS,2)
    %run('OfflineProcessP300.m');
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

hold on
plot(0:40,globalperformances1);
plot(0:40,globalperformances2);
plot(0:40,globalperformances3);
plot(0:40,globalperformances4);
plot(0:40,globalperformances5);
plot(0:40,globalperformances6);
plot(0:40,globalperformances7);
plot(0:40,globalperformances8);
axis([0 40 0 1.05]);
legend('MP ST','MP SIG ST','SIFT','SVM','NN','PE','SHCC','NN Single');
xlabel('Drug Signal Gain');
ylabel('Performance')

%%
globalrepts1=[];
globalrepts2=[];
globalrepts3=[];
globalrepts4=[];
globalrepts5=[];
globalrepts6=[];
globalrepts7=[];
globalrepts8=[];
globalsignalgain=1;
for globalrepetitions=1:10
    % NNET
    globalappyzscore=false;
    globalclassifier=4;
    globalfeaturetype=5;
    run('ERPProcess.m')
    globalrepts1 = [globalrepts1 totals(:,6)];  
    
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalrepts2 = [globalrepts2 totals(:,6)];  
    
    globalappyzscore=true;
    globalclassifier=6;
    globalfeaturetype=1;
    run('ERPProcess.m')
    globalrepts3 = [globalrepts3 totals(:,6)];
    
    globalappyzscore=false;
    globalclassifier=4;
    globalfeaturetype=2;
    run('ERPProcess.m')
    globalrepts4 = [globalrepts4 totals(:,6)];
    
    globalappyzscore=false;
    globalclassifier=1;
    globalfeaturetype=2;
    run('ERPProcess.m')
    globalrepts5 = [globalrepts5 totals(:,6)];
    
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=6;
    run('ERPProcess.m')
    globalrepts6 = [globalrepts6 totals(:,6)];  
    
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=7;
    run('ERPProcess.m')
    globalrepts7 = [globalrepts7 totals(:,6)]; 
    
    globalappyzscore=false;
    globalclassifier=1;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalrepts8 = [globalrepts8 totals(:,6)]; 
end
    
hold on
plot(globalrepts1);
plot(globalrepts2);
plot(globalrepts3);
plot(globalrepts4);
plot(globalrepts5);
plot(globalrepts6);
plot(globalrepts7);
plot(globalrepts8);
axis([1 10 0 1.05]);
legend('MP ST','MP SIG ST','SIFT','SVM','NN','PE','SHCC','NN S');
xlabel('Intensification Sequences');
ylabel('Performance')

figure;
subplot(2,4,1);plot(globalrepts1);title('MP Wavelets');axis([0 10 0 1.05]);
subplot(2,4,2);plot(globalrepts2);title('MP con Seniales');axis([0 10 0 1.05]);
subplot(2,4,3);plot(globalrepts3);title('SIFT');axis([0 10 0 1.05]);
subplot(2,4,4);plot(globalrepts4);title('SVM Multicanal');axis([0 10 0 1.05]);
subplot(2,4,5);plot(globalrepts5);title('NN Multicanal');axis([0 10 0 1.05]);
subplot(2,4,6);plot(globalrepts6);title('PE');axis([0 10 0 1.05]);
subplot(2,4,7);plot(globalrepts7);title('SHCC');axis([0 10 0 1.05]);
subplot(2,4,8);plot(globalrepts8);title('NN Singlechannel');axis([0 10 0 1.05]);
axis([0 10 0 1.05]);
ylabel('Performance')
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

%%
routput=open('routput.mat');
routput = routput.routput;

EEG=open('EEG.mat')
EEG=EEG.EEG;

EEG(8,2,1)

for i=1:12 
    %figure;plot( routput{8}{2}{1}{i}(:,7) )
    %title(sprintf('Label %d',EEG(8,2,i).label));
end




template1=routput{8}{2}{1}{8};
template2=routput{8}{2}{1}{1};

cutrange=37:249;

w = gausswin(size(template1(cutrange,:),1));
for ch=1:8
%template1(cutrange,ch) = template1(cutrange,ch)-(template1(cutrange,ch)*0.9).*w;
end

figure;
plot(template1);
title('Multichannel ERP Template');
axis([0 256 -10 10]);
ylabel('Microvolts')
done
