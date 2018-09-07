function testval = doerpclassification(subjectRange,channelRange,SBJ,classifier)
distancetype='cosine';
k=7;
globalreps=10;
nbofclassespertrial=(2+10)*(10/globalreps);
for subject=subjectRange
    F=SBJ(subject).F;
    epochRange=SBJ(subject).epochRange;
    labelRange=SBJ(subject).labelRange;
    trainingRange=SBJ(subject).trainingRange;
    testRange=SBJ(subject).testRange;
    
    switch classifier
        case 11
            for channel=channelRange
                DE(channel) = NBNNFeatureExtractor(F,channel,trainingRange,labelRange,[1 2],false);
                %[ACC, ERR, AUC, SC(channel)] = NBMultiClass(F,DE(channel),channel,testRange,labelRange,distancetype,k);
                %[ACC, ERR, AUC, SC(channel)] = NBNNClassifier4(F,DE(channel),channel,testRange,labelRange,false,distancetype,k);
                [ACC, ERR, AUC, SC(channel)] = MPP300Classifier2(F,DE(channel),channel,testRange,labelRange,distancetype,k);
                %[ACC, ERR, AUC, SC(channel)] = BciSiftNBNNClassifier(F,DE(channel),channel,testRange,labelRange,0,false);
                
                globalaccij1(subject,channel)=1-ERR/size(testRange,2);
                globalaccij2(subject,channel)=AUC;
                globalsigmaaccij1 = globalaccij1;
            end
            
        case 5
            for channel=channelRange
                [DE(channel), ACC, ERR, AUC, SC(channel)] = LDAClassifier(F,labelRange,trainingRange,testRange,channel);
                globalaccij1(subject,channel)=ACC;
                globalsigmaaccij1 = globalaccij1;
                globalaccij2(subject,channel)=AUC;
            end
        case 4
            for channel=channelRange
                [DE(channel), ACC, ERR, AUC, SC(channel)] = SVMClassifier(F,labelRange,trainingRange,testRange,channel);
                globalaccij1(subject,channel)=ACC;
                globalsigmaaccij1 = globalaccij1;
                globalaccij2(subject,channel)=AUC;
            end
        case 1
            for channel=channelRange
                [DE(channel), ACC, ERR, AUC, SC(channel)] = NNetClassifier(F,labelRange,trainingRange,testRange,channel);
                globalaccij1(subject,channel)=ACC;
                globalsigmaaccij1 = globalaccij1;
                globalaccij2(subject,channel)=AUC;
            end
        case 2
            [AccuracyPerChannel, SigmaPerChannel] = CrossValidated(F,epochRange,labelRange,channelRange, @IterativeNBNNClassifier,1);
            globalaccij1(subject,:)=AccuracyPerChannel
            globalsigmaaccij1(subject,:)=SigmaPerChannel;
            globalaccijpernumberofsamples(globalnumberofepochs,subject,:) = globalaccij1(subject,:);
        case 3
            for channel=channelRange
                [DE(channel), ACC, ERR, AUC, SC(channel)] = IterativeNBNNClassifier(F,channel,trainingRange,labelRange,testRange,false,false);
                
                globalaccij1(subject,channel)=1-ERR/size(testRange,2);
                globalaccij2(subject,channel)=AUC;
                globalsigmaaccij1 = globalaccij1;
            end
        case 6
            for channel=channelRange
                DE(channel) = NBNNFeatureExtractor(F,channel,trainingRange,labelRange,[1 2],false);
                %[ACC, ERR, AUC, SC(channel)] = NBMultiClass(F,DE(channel),channel,testRange,labelRange,distancetype,k);
                %[ACC, ERR, AUC, SC(channel)] = NBNNClassifier4(F,DE(channel),channel,testRange,labelRange,false,distancetype,k);
                [ACC, ERR, AUC, SC(channel)] = NBKNNP300Classifier(F,DE(channel),channel,testRange,labelRange,distancetype,k);
                %[ACC, ERR, AUC, SC(channel)] = BciSiftNBNNClassifier(F,DE(channel),channel,testRange,labelRange,0,false);
                
                globalaccij1(subject,channel)=1-ERR/size(testRange,2);
                globalaccij2(subject,channel)=AUC;
                globalsigmaaccij1 = globalaccij1;
            end
            
    end
    SBJ(subject).DE = DE;
    SBJ(subject).SC = SC;
end


for subject=subjectRange
    % '2'    'B'    'A'    'C'    'I'    '5'    'R'    'O'    'S'    'E'    'Z'  'U'    'P'    'P'    'A'
    % 'G' 'A' 'T' 'T' 'O'    'M' 'E' 'N''T' 'E'   'V''I''O''L''A'  'R''E''B''U''S'
    Speller = SpellMe(F,channelRange,1:17,labelRange,trainingRange,testRange,SBJ(subject).SC);
    
    S = 'TOKENMIRARJUJUYMANSOCINCOJUEGOQUESO';
    a=floor((testRange-1)/12);
    a=unique(a,'stable');
    a=a+1;
    
    S = repmat(S,nbofclassespertrial/12);
    S = reshape( S, [1 size(S,1)*size(S,2)]);
    S=S(1:size(S,2)/(nbofclassespertrial/12));
    
    S=S(a);
    
    SpAcc = [];
    for channel=channelRange
        counter=0;
        for i=1:size(S,2)
            if Speller{channel}{i}==S(i)
                counter=counter+1;
            end
        end
        spellingacc = counter/size(S,2);
        SpAcc(end+1) = spellingacc;
        globalspeller(subject,channel) = spellingacc;
        %globalspeller(subject,channel,globaldelays+1) = spellingacc;
        %globalspellerrep(subject,channel,globalrepetitions) = spellingacc;
        
    end
    [a,b] = max(SpAcc);
end

%experiment=sprintf(' K = %d ',k);
%fid = fopen('experiment.log','a');
%fprintf(fid,'Experiment: %s \n', experiment);
%fprintf(fid,'st %f sv %f scale %f timescale %f qKS %d\n',siftscale(1),siftscale(2),imagescale,timescale,qKS);
%totals = DisplayTotals(subjectRange,globalaccij1,globalspeller,globalaccij2,globalspeller,channels)
%totals(:,6)
%fclose(fid)

%DisplayDescriptorImageFull(F,1,2,1,1,1,false);

testval = globalspeller;

end