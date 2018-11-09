function [epochRange,F, SBJ] = doerpprocess(trainingRange,testRange,papplyzscore,pclassifier,pfeaturetype,prandomdelay,prandomamplitude,globalsubjectrange,globalrepetitions,globalsignalgain,globalsignalsize,globalks)
applyzscore=papplyzscore;
classifier=pclassifier;
featuretype=pfeaturetype;
randomdelay=prandomdelay;
randomamplitude=prandomamplitude;
% Signal Averaging x Selection g.Tec Dataset.

% run('/Users/rramele/work/vlfeat/toolbox/vl_setup')
% run('D:/workspace/vlfeat/toolbox/vl_setup')
% run('C:/vlfeat/toolbox/vl_setup')
% P300 for Healthy Subjects.

globalnumberofepochspertrial=10;
globalaverages= cell(2,1);
globalartifacts = 0;
globalreps=10;
globalnumberofepochs=(2+10)*globalreps-1;

nbofclassespertrial=(2+10)*(10/globalreps);
breakonepochlimit=(2+10)*globalrepetitions-1;

% Clean all the directories where the images are located.
cleanimagedirectory();


% NN.NNNNN
% data.X(sample, channel)
% data.y(sample)  --> 0: no, 1:nohit, 2:hit
% data.y_stim(sample) --> 1-12, 1-6 cols, 7-12 rows

%     'Fz'    'Cz'    'Pz'    'Oz'    'P3'    'P4'    'PO7'    'PO8'

channels={ 'Fz'  ,  'Cz',    'P3' ,   'Pz'  ,  'P4'  , 'PO7'   , 'PO8',  'Oz'};


% Parameters ==========================
subjectRange=[1 2 3 4 6 7 8 9 10 11 13 14 15 16 17 18 19 20 21 22 23];
subjectRange=[1 3 4 6 7 9 10 11 13 14 16 17 18 19 20 21 22 23];
%2,15, 8 high impeadance empty trials.
subjectRange=[1 11 14   16 17 20 22 23];
%subjectRange=22;
subjectRange=globalsubjectrange;
epochRange = 1:120*7*5;
channelRange=1:8;
labelRange = [];
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
Fs=250;
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
    
applyzscore=papplyzscore;
classifier=pclassifier;
featuretype=pfeaturetype;
randomdelay=prandomdelay;
randomamplitude=prandomamplitude;

%downsize=1;timescale=1;amplitude=1;

% =====================================

% EEG(subject,trial,flash)
if (subjectRange(1)<20)
    EEG = prepareEEG(Fs,windowsize,downsize,120,subjectRange,1:8,globalsignalgain,true,false,0,randomdelay,randomamplitude);
    EEG = DrugEEG(subjectRange,globalsignalgain,EEG,globalrandomdelay,globalrandomamplitude);
else
    EEG = prepareEEG(Fs,windowsize,downsize,120,subjectRange,1:8,globalsignalgain,true,true,0,randomdelay,randomamplitude);    
end
% CONTROL
%EEG = randomizeEEG(EEG);

tic
Fs=floor(Fs/downsize);

sqKS = [37; 16; 13; 45; 47; 35; 31; 28;39; 33;   28;  ...
    33; 33; 35; ...
    33; 50; ...
    37; ...
    33; 33; 33; ...
    33; 29; ...
    39];

 sqKS = [37; -1;...
     16;    13;  -1;  45;    47; -1; 35; 31; 28;...
     -1; 39;    35;...
     -1; 50;...
     37;...
     43;    36;    33;...
     28;...
     29;...
     39];
 
 sqKS=globalks;

%%
% Build routput pasting epochs toghether...
for subject=subjectRange
    for trial=1:35
        for classes=1:120/(globalnumberofepochs+1);for i=1:12 hit{subject}{trial}{classes}{i} = 0; end; end
        for classes=1:120/(globalnumberofepochs+1);for i=1:12 routput{subject}{trial}{classes}{i} = []; end; end
        processedflashes=0;
        for flash=1:120
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
    for trial=1:35
        for classes=1:120/(globalnumberofepochs+1);for i=1:12 rcounter{subject}{trial}{classes}{i} = 0; end; end
        for flash=1:120
            classes = floor((flash-1)/(globalnumberofepochs+1))+1;
            rcounter{subject}{trial}{classes}{EEG(subject,trial,flash).stim} = rcounter{subject}{trial}{classes}{EEG(subject,trial,flash).stim}+1;
        end
        % Check if all the epochs contain 10 repetitions.
        
        for classes=1:120/(globalnumberofepochs+1); for i=1:12 assert( rcounter{subject}{trial}{classes}{i} == (120/nbofclassespertrial) ); end; end
    end
end

signalsize = globalsignalsize;
mpdict = wmpdictionary(signalsize,'LstCpt',{{'wpsym4',2},'dct'});
           
                            
for subject=subjectRange
    h=[];
    Word=[];
    for trial=1:35
        for classes=1:120/(globalnumberofepochs+1)
            hh = [];
            for i=1:12
                rput{i} = routput{subject}{trial}{classes}{i};
                channelRange = (1:size(rput{i},2));
                channelsize = size(channelRange,2);
                
                assert( globalrepetitions<10 || artifactcheck || size(rput{i},1)/ceil(Fs*windowsize) == rcounter{subject}{trial}{classes}{i}, 'Something wrong with PtP average. Sizes do not match.');
                
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
    for trial=1:35
        for classes=1:120/(globalnumberofepochs+1)
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
            for trial=1:35
                for classes=1:120/(globalnumberofepochs+1)
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
            for trial=1:35
                for classes=1:120/(globalnumberofepochs+1)
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
            for trial=1:35
                for classes=1:120/(globalnumberofepochs+1)
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
            
            
            for trial=1:35
                for classes=1:120/(globalnumberofepochs+1)
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
                            %feature = (1/norm(feature))*feature;
                            
                            F(channel,label,epoch).hit = hit{subject}{trial}{classes}{i};
                            F(channel,label,epoch).descriptors = feature;
                            F(channel,label,epoch).frames = [];
                            F(channel,label,epoch).stim = i;
                        end
                    end
                end
            end   
        case 5

            for trial=1:35
                for classes=1:120/(globalnumberofepochs+1)
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
            for trial=1:35
                for classes=1:120/(globalnumberofepochs+1)
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
            for trial=1:35
                for classes=1:120/(globalnumberofepochs+1)
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
            for trial=1:35
                for classes=1:120/(globalnumberofepochs+1)
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
            for trial=1:35
                for classes=1:120/(globalnumberofepochs+1)
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
    epochRange=1:epoch;
    %trainingRange = 1:nbofclassespertrial*15;
    %testRange=nbofclassespertrial*15+1:min(nbofclassespertrial*35,epoch);
    
    %trainingRange=1:nbofclasses*35;
    
    SBJ(subject).F = F;
    SBJ(subject).epochRange = epochRange;
    SBJ(subject).labelRange = labelRange;
    SBJ(subject).trainingRange = trainingRange;
    SBJ(subject).testRange = testRange;
end

end