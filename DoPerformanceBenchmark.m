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
subjectRange=[21];

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
    

    [epochRange, F, SBJ] = doerpprocess(trainingRange,testRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude,globalrepetitions,globalsignalgain,globalsignalsize);
    [ErrorPerChannel, SigmaPerChannel] = CrossValidatedSpellerPerformance(epochRange,subjectRange,SBJ,channelRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude);
    globalperfs(globalrepetitions,:,:) = [1-ErrorPerChannel(21,:); SigmaPerChannel(21,:)];
    [a,b] = max(globalperfs(10,1,:));
    globalrepts1 = [globalrepts1 1-ErrorPerChannel(21,b)];  
    globalchannel1 = b;
    
    
end
hhhh
for globalrepetitions=1:10
    % MP 2
    globalappyzscore=false;
    globalclassifier=11;
    globalfeaturetype=4;
    [epochRange, F, SBJ] = doerpprocess(trainingRange,testRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude,globalrepetitions,globalsignalgain,globalsignalsize);
    [ErrorPerChannel, SigmaPerChannel] = CrossValidatedSpellerPerformance(epochRange,subjectRange,SBJ,channelRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude);
    globalperfs(globalrepetitions,:,:) = [1-ErrorPerChannel(21,:); SigmaPerChannel(21,:)];
    [a,b] = max(globalperfs(10,1,:));
    globalrepts2 = [globalrepts2 1-ErrorPerChannel(21,b)];  
    globalchannel2 = b;
    
    % SIFT
    globalappyzscore=true;
    globalclassifier=6;
    globalfeaturetype=1;
    [epochRange, F, SBJ] = doerpprocess(trainingRange,testRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude,globalrepetitions,globalsignalgain,globalsignalsize);
    [ErrorPerChannel, SigmaPerChannel] = CrossValidatedSpellerPerformance(epochRange,subjectRange,SBJ,channelRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude);
    globalperfs(globalrepetitions,:,:) = [1-ErrorPerChannel(21,:); SigmaPerChannel(21,:)];
    [a,b] = max(globalperfs(10,1,:));
    globalrepts3 = [globalrepts3 1-ErrorPerChannel(21,b)];  
    globalchannel3 = b;
    
    % SVM 
    globalappyzscore=false;
    globalclassifier=4;
    globalfeaturetype=4;
    [epochRange, F, SBJ] = doerpprocess(trainingRange,testRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude,globalrepetitions,globalsignalgain,globalsignalsize);
    [ErrorPerChannel, SigmaPerChannel] = CrossValidatedSpellerPerformance(epochRange,subjectRange,SBJ,channelRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude);
    globalperfs(globalrepetitions,:,:) = [1-ErrorPerChannel(21,:); SigmaPerChannel(21,:)];
    [a,b] = max(globalperfs(10,1,:));
    globalrepts4 = [globalrepts4 1-ErrorPerChannel(21,b)];  
    globalchannel4 = b;
    
    % PE
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=6;
    [epochRange, F, SBJ] = doerpprocess(trainingRange,testRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude,globalrepetitions,globalsignalgain,globalsignalsize);
    [ErrorPerChannel, SigmaPerChannel] = CrossValidatedSpellerPerformance(epochRange,subjectRange,SBJ,channelRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude);
    globalperfs(globalrepetitions,:,:) = [1-ErrorPerChannel(21,:); SigmaPerChannel(21,:)];
    [a,b] = max(globalperfs(10,1,:));
    globalrepts6 = [globalrepts6 1-ErrorPerChannel(21,b)];  
    globalchannel6 = b;
    
    % SHCC
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=7;
    [epochRange, F, SBJ] = doerpprocess(trainingRange,testRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude,globalrepetitions,globalsignalgain,globalsignalsize);
    [ErrorPerChannel, SigmaPerChannel] = CrossValidatedSpellerPerformance(epochRange,subjectRange,SBJ,channelRange,globalappyzscore,globalclassifier,globalfeaturetype,globalrandomdelay,globalrandomamplitude);
    globalperfs(globalrepetitions,:,:) = [1-ErrorPerChannel(21,:); SigmaPerChannel(21,:)];
    [a,b] = max(globalperfs(10,1,:));
    globalrepts7 = [globalrepts7 1-ErrorPerChannel(21,b)];  
    globalchannel7 = b;
end