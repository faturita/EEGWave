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
    % PE
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=7;
    run('ERPProcess.m')
    globalperformances7 = [globalperformances7 totals(:,6)];
end

hold on
plot(0:40,globalperformances1);
plot(0:40,globalperformances2);
plot(0:40,globalperformances3);
plot(0:40,globalperformances4);
plot(0:40,globalperformances5);
plot(0:40,globalperformances6);
plot(0:40,globalperformances7);
axis([0 40 0 1.05]);
legend('MP ST','MP SIG ST','SIFT','SVM','NN','PE','SHCC');
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
globalsignalgain=3;
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
end
    
hold on
plot(globalrepts1);
plot(globalrepts2);
plot(globalrepts3);
plot(globalrepts4);
plot(globalrepts5);
plot(globalrepts6);
plot(globalrepts7);
axis([0 10 0 1.05]);
legend('MP ST','MP SIG ST','SIFT','SVM','NN','PE','SHCC');
xlabel('Intensification Sequences');
ylabel('Performance')
save
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
