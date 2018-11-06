
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
globalsignalsize=168;
for globalrepetitions=1:15
    
    % MP1
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=5;
    run('BCICompetitionProcess.m')
    globalrepts1 = globalspellerrep;
    
    % MP 2
    globalappyzscore=false;
    globalclassifier=11;
    globalfeaturetype=4;
    run('BCICompetitionProcess.m')
    globalrepts2 = globalspellerrep;
    
    % SIFT
    globalappyzscore=true;
    globalclassifier=6;
    globalfeaturetype=1;
    run('BCICompetitionProcess.m')
    globalrepts3 = globalspellerrep;
    
    % SVM 
    globalappyzscore=false;
    globalclassifier=4;
    globalfeaturetype=4;
    run('BCICompetitionProcess.m')
    globalrepts4 = globalspellerrep;
    
    % PE
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=6;
    run('BCICompetitionProcess.m')
    globalrepts6 = globalspellerrep;
    
    % SHCC
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=7;
    run('BCICompetitionProcess.m')
    globalrepts7 = globalspellerrep;
    
end
    