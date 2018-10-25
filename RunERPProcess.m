clear all;
close all;

globalrepts1=[];
globalrepts2=[];
globalrepts3=[];
globalrepts6=[];
globalrepts7=[];
globalrepts4=[];

globalclassifier=Classifiers.nn;
globalfeaturetype=Features.multichannel;
globalrepetitions=10;
globalapplyzscore=false;
globalrandomdelay=false;
globalrandomamplitude=false;
globaldistancetype='euclidean';
globalk=7;
globalsignalgain=2.2;
globalsignalsize=64;
globalsubjectrange=[21,24,25,26];
globalsubjectrange=[3,4,6,7];
globalks= [37; -1;...
     16;    13;  -1;  45;    47; -1; 35; 31; 28;...
     -1; 39;    35;...
     -1; 50;...
     37;...
     43;    36;    33;...
     28;...
     29;...
     39; 28; 28; 28];
%run('ERPProcess.m')

%%
clear globalspellerrep
for globalrepetitions=1:10
    
    % MP1

    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=5;
    run('ERPProcess.m')
    globalrepts1=globalspellerrep;
    
end
    clear globalspellerrep
for globalrepetitions=1:10
    
    % MP 2

    globalappyzscore=false;
    globalclassifier=11;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalrepts2 = globalspellerrep;
end
    clear globalspellerrep
for globalrepetitions=1:10    
    % SIFT
    globalappyzscore=true;
    globalclassifier=6;
    globalfeaturetype=1;
    globaldistancetype='cosine';
    run('ERPProcess.m')
    globaldistancetype='euclidean';
    globalrepts3 = globalspellerrep;
end
    clear globalspellerrep
for globalrepetitions=1:10    
    % PE
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=6;
    globalm=2;globalwindowsize=10;
    run('ERPProcess.m')
    globalrepts6 = globalspellerrep;
end
    clear globalspellerrep
for globalrepetitions=1:10    
    % SHCC
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=7;
    run('ERPProcess.m')
    globalrepts7 = globalspellerrep;
end
clear globalspellerrep
for globalrepetitions=1:10   
    % SVM 

    globalappyzscore=false;
    globalclassifier=4;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalrepts4 = globalspellerrep;

end

