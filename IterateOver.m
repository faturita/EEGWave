%clear all
%close all
globalrepetitions=1;
globalsignalsize=64;
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


