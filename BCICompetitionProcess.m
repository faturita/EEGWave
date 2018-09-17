% Signal Averaging x Selection g.Tec Dataset.

% run('/Users/rramele/work/vlfeat/toolbox/vl_setup')
% run('D:/workspace/vlfeat/toolbox/vl_setup')
% run('C:/vlfeat/toolbox/vl_setup')
% P300 for Healthy Subjects.

clear globalspeller
clear globalaccij1
clear globalaccij2

rng(396545);

globalnumberofepochspertrial=15;
globalaverages= cell(2,1);
globalartifacts = 0;
globalreps=15;
globalnumberofepochs=(2+10)*globalreps-1;

clear mex;clearvars  -except global*;close all;clc;

nbofclassespertrial=(2+10)*(15/globalreps);
breakonepochlimit=(2+10)*globalrepetitions-1;

% Clean all the directories where the images are located.
cleanimagedirectory();


% NN.NNNNN
% data.X(sample, channel)
% data.y(sample)  --> 0: no, 1:nohit, 2:hit
% data.y_stim(sample) --> 1-12, 1-6 cols, 7-12 rows

%     'Fz'    'Cz'    'Pz'    'Oz'    'P3'    'P4'    'PO7'    'PO8'

channels={ 'FC5','FC3','FC1','FCZ', ...
'FC2','FC4','FC6','C5',...
'C3','C1','Cz','C2',...
'C4','C6','CP5','CP3',...
'CP1','CPz','CP2','CP4',...
'CP6','FP1','FPz','FP2',...
'AF7','AF3','AFz','AF4',...
'AF8','Fz','F5','F3',...
'F1','Fz','F2','F4',...
'F6','F8','FT7','FT8',...
'T7','T8','T9','T10',...
'TP7','TP8','P7','P5',...
'P3','P1','Pz','P2',...
'P4','P6','P8','PO7',...
'PO3','POz','PO4','PO8',...
'O1','Oz','O2','Iz'}


% Parameters ==========================
siftscale = [3 3];  % Determines lamda length [ms] and signal amp [microV]
imagescale=4;    % Para agarrar dos decimales NN.NNNN
timescale=4;
qKS=32-3;
minimagesize=floor(sqrt(2)*15*siftscale(2)+1);
amplitude=3;   % Best 1-5
adaptative=false;
k=7; % Best
artifactcheck=true;

invariantlocation=false;
siftdescriptordensity=1;
Fs=240;
windowsize=1;
expcode=2400;
show=0;
downsize=15;
applyzscore=true;
featuretype=1;
distancetype='euclidean';
classifier=6;

artifactcheck=false;

  
    %globalappyzscore=false;
    %globalclassifier=4;
    %globalfeaturetype=5;
    %globalsignalgain=1.2;
    %globalsignalsize=60;
    
% applyzscore=globalappyzscore;
% classifier=globalclassifier;
% featuretype=globalfeaturetype;
% randomdelay=globalrandomdelay;
% randomamplitude=globalrandomamplitude;

%downsize=1;timescale=1;amplitude=1;

% =====================================

% EEG(subject,trial,flash)
%EEG = prepareEEG(Fs,windowsize,downsize,120,subjectRange,1:8,globalsignalgain,true,0,randomdelay,randomamplitude);
imagescale=4;
timescale=4*2;
siftscale = [ 3*2 3];
qKS=55;
minimagesize=floor(sqrt(2)*15*siftscale(2)+1);
amplitude=4;
channelRange=1:64;
downsize=16;
[EEG, stimRange, labelRange] = loadBCICompetition(Fs, windowsize, downsize, 180, 1:1,channelRange);
subjectRange=1:1;

% CONTROL
%EEG = randomizeEEG(EEG);

tic
Fs=floor(Fs/downsize);

sqKS=[60];

%%
% Build routput pasting epochs toghether...
for subject=subjectRange
    for trial=1:73
        for classes=1:180/(globalnumberofepochs+1);for i=1:12 hit{subject}{trial}{classes}{i} = 0; end; end
        for classes=1:180/(globalnumberofepochs+1);for i=1:12 routput{subject}{trial}{classes}{i} = []; end; end
        processedflashes=0;
        for flash=1:180
            classes = floor((flash-1)/(globalnumberofepochs+1))+1;
            if ((breakonepochlimit>0) && (processedflashes > breakonepochlimit))
                break;
            end
            % Skip artifacts
            if (artifactcheck && EEG(subject,trial,flash).isartifact)
                continue;
            end
            processedflashes = processedflashes+1;
            output = EEG(subject,trial,flash).EEG;
            routput{subject}{trial}{classes}{EEG(subject,trial,flash).stim} = [routput{subject}{trial}{classes}{EEG(subject,trial,flash).stim} ;output];
            hit{subject}{trial}{classes}{EEG(subject,trial,flash).stim} = EEG(subject,trial,flash).label;
        end
    end
end

for subject=subjectRange
    for trial=1:73
        for classes=1:180/(globalnumberofepochs+1);for i=1:12 rcounter{subject}{trial}{classes}{i} = 0; end; end
        for flash=1:180
            classes = floor((flash-1)/(globalnumberofepochs+1))+1;
            rcounter{subject}{trial}{classes}{EEG(subject,trial,flash).stim} = rcounter{subject}{trial}{classes}{EEG(subject,trial,flash).stim}+1;
        end
        % Check if all the epochs contain 10 repetitions.
        
        for classes=1:180/(globalnumberofepochs+1); for i=1:12 assert( rcounter{subject}{trial}{classes}{i} == (180/nbofclassespertrial) ); end; end
    end
end

signalsize = globalsignalsize;
mpdict = wmpdictionary(signalsize,'LstCpt',{{'wpsym4',2},'dct'});
           
                            
for subject=subjectRange
    h=[];
    Word=[];
    for trial=1:73
        for classes=1:180/(globalnumberofepochs+1)
            hh = [];
            for i=1:12
                rput{i} = routput{subject}{trial}{classes}{i};
                channelRange = (1:size(rput{i},2));
                channelsize = size(channelRange,2);
                
                assert( globalrepetitions<15 || artifactcheck || size(rput{i},1)/ceil(Fs*windowsize) == rcounter{subject}{trial}{classes}{i}, 'Something wrong with PtP average. Sizes do not match.');
                
                %rput{i}=reshape(rput{i},[ceil(Fs*windowsize) size(rput{i},1)/ceil(Fs*windowsize) channelsize]);
                rput{i}=reshape(rput{i},[(Fs*windowsize) size(rput{i},1)/(Fs*windowsize) channelsize]); 
                
                %dly = de2bi(globaldelays,10);
                %rput{i} = TimeWarping(rput{i},dly,channelRange);
                
                %rput{i} = DynamicTimeWarping(rput{i},channelRange);
                
                %rput{i}= rput{i}(size(rput{i},1)/4+1:size(rput{i},1)/4+1+size(rput{i},1)/2-1,:,:);
                
                for channel=channelRange
                    rmean{i}(:,channel) = mean(rput{i}(:,:,channel),2);
                end
                
                if (hit{subject}{trial}{classes}{i} == 2)
                    h = [h i];
                    hh = [hh i];
                end
                routput{subject}{trial}{classes}{i} = rmean{i};
            end
            Word = [Word SpellMeLetter(hh(1),hh(2))];
        end
    end
end

for subject=subjectRange
    for trial=1:73
        for classes=1:180/(globalnumberofepochs+1)
            for i=1:12
                
                rmean{i} = routput{subject}{trial}{classes}{i};
                
                if (timescale ~= 1)
                    for c=channelRange
                        %rsignal{i}(:,c) = resample(rmean{i}(:,c),size(rmean{i},1)*timescale,size(rmean{i},1));
                        rsignal{i}(:,c) = resample(rmean{i}(:,c),1:size(rmean{i},1),timescale);
                    end
                else
                    rsignal{i} = rmean{i};
                end
                
                if (applyzscore)
                    rsignal{i} = zscore(rsignal{i})*amplitude;
                else
                    rsignal{i} = rsignal{i}*amplitude;
                end
                
                routput{subject}{trial}{classes}{i} = rsignal{i};
            end
        end
    end
end


for subject=subjectRange
    epoch=0;
    labelRange=[];
    epochRange=[];
    stimRange=[];
    
    switch (featuretype)
        case 1
            for trial=1:73
                for classes=1:180/(globalnumberofepochs+1)
                    for i=1:12
                        epoch=epoch+1;
                        label = hit{subject}{trial}{classes}{i};
                        labelRange(epoch) = label;
                        stimRange(epoch) = i;
                        DS = [];
                        rsignal{i}=routput{subject}{trial}{classes}{i};
                        for channel=channelRange
                            %minimagesize=1;
                            [eegimg, DOTS, zerolevel] = eegimage(channel,rsignal{i},imagescale,1, false,minimagesize);
                            %siftscale(1) = 11.7851;
                            %siftscale(2) = (height-1)/(sqrt(2)*15);
                            %saveeegimage(subject,epoch,label,channel,eegimg);
                            zerolevel = size(eegimg,1)/2;
                            
                            %             if ((size(find(trainingRange==epoch),2)==0))
                            %                qKS=ceil(0.20*(Fs)*timescale):floor(0.20*(Fs)*timescale+(Fs)*timescale/4-1);
                            %             else
                            qKS=sqKS(subject);
                            if (signalsize==250)
                                siftscale(1) = 12;
                                qKS=sqKS(subject)+79;
                            end
                            %qKS=qKS-10:qKS+10;
                            %qKS=qKS';
                            %zerolevel=0;
                            %qKS=125;
                            %qKS=32;
                            %             end
                            %qKS=-10+sqKS(subject):10+sqKS(subject);
                            %qKS=qKS';
                            
                            if (invariantlocation)
                                [pks,loc] = findpeaks(rsignal{i}(:,channel));
                                f=loc(ceil(size(loc,1)/2));
                                qKS=f(1);
                                if (qKS<=0)
                                    qKS=sqKS(subject);
                                end
                            end
                            
                            
                            
                            [frames, desc] = PlaceDescriptorsByImage(eegimg, DOTS,siftscale, siftdescriptordensity,qKS,zerolevel,false,distancetype);
                            F(channel,label,epoch).stim = i;
                            F(channel,label,epoch).hit = hit{subject}{trial}{classes}{i};
                            
                            
                            F(channel,label,epoch).descriptors = desc;
                            F(channel,label,epoch).frames = frames;
                        end
                    end
                end
            end
        case 2
            for trial=1:73
                for classes=1:180/(globalnumberofepochs+1)
                    for i=1:12
                        epoch=epoch+1;
                        label = hit{subject}{trial}{classes}{i};
                        labelRange(epoch) = label;
                        stimRange(epoch) = i;
                        DS = [];
                        rsignal{i}=routput{subject}{trial}{classes}{i};
                        
                        feature = [];
                        
                        for channel=channelRange
                            feature = [feature ; rsignal{i}(:,channel)]; % 1:17
                        end
                        
                        for channel=channelRange
                            F(channel,label,epoch).hit = hit{subject}{trial}{classes}{i};
                            F(channel,label,epoch).descriptors = feature;
                            F(channel,label,epoch).frames = [];
                            F(channel,label,epoch).stim = i;
                        end
                    end
                end
            end
        case 3
            for trial=1:73
                for classes=1:180/(globalnumberofepochs+1)
                    for i=1:12
                        epoch=epoch+1;
                        label = hit{subject}{trial}{classes}{i};
                        labelRange(epoch) = label;
                        stimRange(epoch) = i;
                        DS = [];
                        rsignal{i}=routput{subject}{trial}{classes}{i};
                        for channel=channelRange
                            %minimagesize=1;
                            [eegimg, DOTS, zerolevel, height] = eegimageinvariant(channel,rsignal{i},imagescale,1, false,minimagesize);
                            
                            siftscale(1) = 3;
                            siftscale(2) = (height-1)/(sqrt(2)*15);
                            saveeegimage(subject,epoch,label,channel,eegimg);
                            zerolevel = size(eegimg,1)/2;
                            
                            %             if ((size(find(trainingRange==epoch),2)==0))
                            %                qKS=ceil(0.20*(Fs)*timescale):floor(0.20*(Fs)*timescale+(Fs)*timescale/4-1);
                            %             else
                            if (invariantlocation)
                                [pks,loc] = findpeaks(rsignal{i}(:,channel));
                                f=loc(ceil(size(loc,1)/2));
                                qKS=f(1);
                                if (qKS<=0)
                                    qKS=sqKS(subject);
                                end
                            end
                            %qKS=qKS-10:qKS+10;
                            %qKS=qKS';
                            %qKS=125;
                            %             end
                            
                            
                            [frames, desc] = PlaceDescriptorsByImage(eegimg, DOTS,siftscale, siftdescriptordensity,qKS,zerolevel,false,distancetype);
                            F(channel,label,epoch).stim = i;
                            F(channel,label,epoch).hit = hit{subject}{trial}{classes}{i};
                            
                            
                            F(channel,label,epoch).descriptors = desc;
                            F(channel,label,epoch).frames = frames;
                        end
                    end
                end
            end
        case 4
            
            
            for trial=1:73
                for classes=1:180/(globalnumberofepochs+1)
                    for i=1:12
                        epoch=epoch+1;
                        label = hit{subject}{trial}{classes}{i};
                        labelRange(epoch) = label;
                        stimRange(epoch) = i;
                        DS = [];
                        rsignal{i}=routput{subject}{trial}{classes}{i};
                        
                        feature = [];
                        
                        for channel=channelRange
                            feature = rsignal{i}(:,channel);
                            feature = (1/norm(feature))*feature;
                            
                            F(channel,label,epoch).hit = hit{subject}{trial}{classes}{i};
                            F(channel,label,epoch).descriptors = feature;
                            F(channel,label,epoch).frames = [];
                            F(channel,label,epoch).stim = i;
                        end
                    end
                end
            end   
        case 5

            for trial=1:73
                for classes=1:180/(globalnumberofepochs+1)
                    for i=1:12
                        epoch=epoch+1;
                        label = hit{subject}{trial}{classes}{i};
                        labelRange(epoch) = label;
                        stimRange(epoch) = i;
                        DS = [];
                        rsignal{i}=routput{subject}{trial}{classes}{i};
                        
                        feature = [];
                        
                        for channel=channelRange
                            feature = rsignal{i}(:,channel);
  
                            [yfit,R,COEFF,IOPT,QUAL] = wmpalg('BMP',feature,mpdict(:,1:end));
                            feature = zeros(1,length(mpdict));
                            [~,I] = sort(IOPT);
                            feature(IOPT)=  COEFF;

                            feature = (1/norm(feature))*feature;
                            
                            feature=feature';
                            
                            F(channel,label,epoch).hit = hit{subject}{trial}{classes}{i};
                            F(channel,label,epoch).descriptors = feature;
                            F(channel,label,epoch).frames = [];
                            F(channel,label,epoch).stim = i;
                        end
                    end
                end
            end  
        case 6
            for trial=1:73
                for classes=1:180/(globalnumberofepochs+1)
                    for i=1:12
                        epoch=epoch+1;
                        label = hit{subject}{trial}{classes}{i};
                        labelRange(epoch) = label;
                        stimRange(epoch) = i;
                        DS = [];
                        rsignal{i}=routput{subject}{trial}{classes}{i};
                        
                        feature = [];
                        
                        for channel=channelRange
                            feature = rsignal{i}(:,channel);
  
                            feature=PE(feature,1,2,10);
                            
                            feature=feature';
                            
                            F(channel,label,epoch).hit = hit{subject}{trial}{classes}{i};
                            F(channel,label,epoch).descriptors = feature;
                            F(channel,label,epoch).frames = [];
                            F(channel,label,epoch).stim = i;
                        end
                    end
                end
            end              
        case 7
            for trial=1:73
                for classes=1:180/(globalnumberofepochs+1)
                    for i=1:12
                        epoch=epoch+1;
                        label = hit{subject}{trial}{classes}{i};
                        labelRange(epoch) = label;
                        stimRange(epoch) = i;
                        DS = [];
                        rsignal{i}=routput{subject}{trial}{classes}{i};
                        
                        feature = [];
                        
                        for channel=channelRange
                            feature = rsignal{i}(:,channel);

                            s=chainCode(1:size(routput{subject}{trial}{classes}{1},1),rsignal{i}(:,channel),1,size(routput{subject}{trial}{classes}{1},1)-1,0,0);
                            feature = s.chainSHCC';
                            
                            F(channel,label,epoch).hit = hit{subject}{trial}{classes}{i};
                            F(channel,label,epoch).descriptors = feature;
                            F(channel,label,epoch).frames = [];
                            F(channel,label,epoch).stim = i;
                        end
                    end
                end
            end  
        case 8
            for trial=1:73
                for classes=1:180/(globalnumberofepochs+1)
                    for i=1:12
                        epoch=epoch+1;
                        label = hit{subject}{trial}{classes}{i};
                        labelRange(epoch) = label;
                        stimRange(epoch) = i;
                        DS = [];
                        rsignal{i}=routput{subject}{trial}{classes}{i};
                        
                        feature = [];
                        
                        for channel=channelRange
                            feature = rsignal{i}(:,channel);

                            s=chainCode(1:size(routput{subject}{trial}{classes}{1},1),rsignal{i}(:,channel),1,size(routput{subject}{trial}{classes}{1},1)-1,0,0);
                            feature = s.chainSHCC';
                            
                            F(channel,label,epoch).hit = hit{subject}{trial}{classes}{i};
                            F(channel,label,epoch).descriptors = feature;
                            F(channel,label,epoch).frames = [];
                            F(channel,label,epoch).stim = i;
                        end
                    end
                end
            end 
        case 9
            for trial=1:73
                for classes=1:180/(globalnumberofepochs+1)
                    for i=1:12
                        epoch=epoch+1;
                        label = hit{subject}{trial}{classes}{i};
                        labelRange(epoch) = label;
                        stimRange(epoch) = i;
                        DS = [];
                        rsignal{i}=routput{subject}{trial}{classes}{i};
                        
                        feature = [];
                        
                        for channel=channelRange
                            feature = rsignal{i}(:,channel);

                            feature = MIDSFeatureSignal(rsignal{i}(:,channel),1/Fs)
                            
                            F(channel,label,epoch).hit = hit{subject}{trial}{classes}{i};
                            F(channel,label,epoch).descriptors = feature;
                            F(channel,label,epoch).frames = [];
                            F(channel,label,epoch).stim = i;
                        end
                    end
                end
            end 
            
            
    end
    % ACORDATE QUE SI k>1 LA CLASIFICACION NO DA PERFECTA AUNQUE
    % SE USE EL MISMO CONJUNTO DE ENTRENAMIENTO QUE DE TESTEO
    epochRange=1:epoch;
    trainingRange = 1:nbofclassespertrial*42;
    testRange=nbofclassespertrial*42+1:min(nbofclassespertrial*73,epoch);
    
    %trainingRange=1:nbofclasses*35;
    
    SBJ(subject).F = F;
    SBJ(subject).epochRange = epochRange;
    SBJ(subject).labelRange = labelRange;
    SBJ(subject).trainingRange = trainingRange;
    SBJ(subject).testRange = testRange;
end

%%
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
    Speller = SpellMe(F,channelRange,43:73,labelRange,trainingRange,testRange,SBJ(subject).SC,true);
    
    S = 'FOODMOOTHAMPIECAKETUNAZYGOT4567';    
    
    S = repmat(S,nbofclassespertrial/12);
    S = reshape( S, [1 size(S,1)*size(S,2)]);
    S=S(1:size(S,2)/(nbofclassespertrial/12));
    
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
        globalspellerrep(subject,channel,globalrepetitions) = spellingacc;
        
    end
    [a,b] = max(SpAcc);
end

experiment=sprintf(' K = %d ',k);
fid = fopen('experiment.log','a');
fprintf(fid,'Experiment: %s \n', experiment);
fprintf(fid,'st %f sv %f scale %f timescale %f qKS %d\n',siftscale(1),siftscale(2),imagescale,timescale,qKS);
totals = DisplayTotals(subjectRange,globalaccij1,globalspeller,globalaccij2,globalspeller,channels)
totals(:,6)
fclose(fid)

%DisplayDescriptorImageFull(F,1,2,1,1,1,false);