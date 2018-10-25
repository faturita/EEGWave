
%
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

globalapplyzscore=true;
globalrandomdelay=false;
globalrandomamplitude=false;
globaldistancetype='cosine';
globalk=7;
globalks=sqKS;
globalm=2;globalwindowsize=10;


for globalrepetitions=1:10
    
    % MP1
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=5;
    run('ERPProcess.m')
    globalrepts1 = [globalrepts1 totals(:,6)];  
    globalchannel1 = totals(:,5);
    
    % MP 2
    globalappyzscore=false;
    globalclassifier=11;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalrepts2 = [globalrepts2 totals(:,6)];  
    globalchannel2 = totals(:,5);
    
    % SIFT
    globalappyzscore=true;
    globalclassifier=6;
    globalfeaturetype=1;
    run('ERPProcess.m')
    globalrepts3 = [globalrepts3 totals(:,6)];
    globalchannel3 = totals(:,5);
    
    % SVM 
    globalappyzscore=false;
    globalclassifier=4;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalrepts4 = [globalrepts4 totals(:,6)];
    globalchannel4 = totals(:,5);
     
    % NN m-c
%     globalappyzscore=false;
%     globalclassifier=1;
%     globalfeaturetype=2;
%     run('ERPProcess.m')
%     globalrepts5 = [globalrepts5 totals(:,6)];
%     globalchannel5 = totals(:,5);
    
    % PE
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=6;
    run('ERPProcess.m')
    globalrepts6 = [globalrepts6 totals(:,6)];  
    globalchannel6 = totals(:,5);
    global6 = globalspellerrep;
    
    % SHCC
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=7;
    run('ERPProcess.m')
    globalrepts7 = [globalrepts7 totals(:,6)]; 
    globalchannel7 = totals(:,5);
    global7 = globalspellerrep;
    
    % NN s-c
%     globalappyzscore=false;
%     globalclassifier=1;
%     globalfeaturetype=4;
%     run('ERPProcess.m')
%     globalrepts8 = [globalrepts8 totals(:,6)]; 
%     globalchannel8 = totals(:,5);
    
    % Raw signal single channel
%     globalappyzscore=false;
%     globalclassifier=6;
%     globalfeaturetype=4;
%     run('ERPProcess.m')
%     globalrepts9 = [globalrepts9 totals(:,6)]; 
%     globalchannel9 = totals(:,5);
    
    % Raw signal multi channel
%     globalappyzscore=false;
%     globalclassifier=6;
%     globalfeaturetype=2;
%     run('ERPProcess.m')
%     globalrepts10 = [globalrepts10 totals(:,6)]; 
%     globalchannel10 = totals(:,5);
end
    



