%%
globalperfs=zeros(10,2,8);
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
channelRange=1:8;
trainingRange=[];
testRange=[];
globalsubjectrange=[21,24,25,26];

globalks= [37; -1;...
     16;    13;  -1;  45;    47; -1; 35; 31; 28;...
     -1; 39;    35;...
     -1; 50;...
     37;...
     43;    36;    33;...
     28;...
     29;...
     39; 28; 28; 28];
 
for globalrepetitions=1:10
    
    % MP1
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=5;
    
    [epochRange, F, SBJ] = doerpprocess(trainingRange,testRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude,globalsubjectrange,globalrepetitions,globalsignalgain,globalsignalsize,globalks);
    [ErrorPerChannel, SigmaPerChannel] = CrossValidatedSpellerPerformance(epochRange,globalsubjectrange,SBJ,channelRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude);
    globalperfs(globalsubjectrange,channelRange,globalrepetitions) = 1-ErrorPerChannel(globalsubjectrange,:); 
    globalrepts1 = globalperfs;
end
clear globalperfs
clear ErrorPerChannel
clear SigmaPerChannel
clear SBJ
clear F
for globalrepetitions=1:10
    % MP 2
    globalappyzscore=false;
    globalclassifier=11;
    globalfeaturetype=4;
    [epochRange, F, SBJ] = doerpprocess(trainingRange,testRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude,globalsubjectrange,globalrepetitions,globalsignalgain,globalsignalsize,globalks);
    [ErrorPerChannel, SigmaPerChannel] = CrossValidatedSpellerPerformance(epochRange,globalsubjectrange,SBJ,channelRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude);
    globalperfs(globalsubjectrange,channelRange,globalrepetitions) = 1-ErrorPerChannel(globalsubjectrange,:); 
    globalrepts2 = globalperfs;
end
clear globalperfs
clear ErrorPerChannel
clear SigmaPerChannel
clear SBJ
clear F
for globalrepetitions=1:10
    
    % SIFT
    globalappyzscore=true;
    globalclassifier=6;
    globalfeaturetype=1;
    [epochRange, F, SBJ] = doerpprocess(trainingRange,testRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude,globalsubjectrange,globalrepetitions,globalsignalgain,globalsignalsize,globalks);
    [ErrorPerChannel, SigmaPerChannel] = CrossValidatedSpellerPerformance(epochRange,globalsubjectrange,SBJ,channelRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude);
    globalperfs(globalsubjectrange,channelRange,globalrepetitions) = 1-ErrorPerChannel(globalsubjectrange,:); 
    globalrepts3 = globalperfs;
end
clear globalperfs
clear ErrorPerChannel
clear SigmaPerChannel
clear SBJ
clear F
for globalrepetitions=1:10
    
    % SVM 
    globalappyzscore=false;
    globalclassifier=4;
    globalfeaturetype=4;
    [epochRange, F, SBJ] = doerpprocess(trainingRange,testRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude,globalsubjectrange,globalrepetitions,globalsignalgain,globalsignalsize,globalks);
    [ErrorPerChannel, SigmaPerChannel] = CrossValidatedSpellerPerformance(epochRange,globalsubjectrange,SBJ,channelRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude);
    globalperfs(globalsubjectrange,channelRange,globalrepetitions) = 1-ErrorPerChannel(globalsubjectrange,:); 
    globalrepts4 = globalperfs;
end
clear globalperfs
clear ErrorPerChannel
clear SigmaPerChannel
clear SBJ
clear F
for globalrepetitions=1:10
    
    % PE
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=6;
    [epochRange, F, SBJ] = doerpprocess(trainingRange,testRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude,globalsubjectrange,globalrepetitions,globalsignalgain,globalsignalsize,globalks);
    [ErrorPerChannel, SigmaPerChannel] = CrossValidatedSpellerPerformance(epochRange,globalsubjectrange,SBJ,channelRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude);
    globalperfs(globalsubjectrange,channelRange,globalrepetitions) = 1-ErrorPerChannel(globalsubjectrange,:); 
    globalrepts6 = globalperfs;
end
clear globalperfs
clear ErrorPerChannel
clear SigmaPerChannel
clear SBJ
clear F
for globalrepetitions=1:10
    
    % SHCC
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=7;
    [epochRange, F, SBJ] = doerpprocess(trainingRange,testRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude,globalsubjectrange,globalrepetitions,globalsignalgain,globalsignalsize,globalks);
    [ErrorPerChannel, SigmaPerChannel] = CrossValidatedSpellerPerformance(epochRange,globalsubjectrange,SBJ,channelRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude);
    globalperfs(globalsubjectrange,channelRange,globalrepetitions) = 1-ErrorPerChannel(globalsubjectrange,:); 
    globalrepts7 = globalperfs;
end
