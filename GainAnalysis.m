% Signal Averaging x Selection g.Tec Dataset.

% run('/Users/rramele/work/vlfeat/toolbox/vl_setup')
% run('D:/workspace/vlfeat/toolbox/vl_setup')
% run('C:/vlfeat/toolbox/vl_setup')
% P300 for Healthy Subjects.

clear globalspeller
clear globalaccij1
clear globalaccij2

rng(396545);

globalrepetitions=10;
globalnumberofepochspertrial=10;
globalaverages= cell(2,1);
globalartifacts = 0;
globalreps=10;
globalnumberofepochs=(2+10)*globalreps-1;

clear mex;clearvars  -except global*;close all;clc;

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
subjectRange=21;
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
distancetype='cosine';
classifier=6;

artifactcheck=false;
  
    globalappyzscore=false;
    globalclassifier=4;
    globalfeaturetype=5;
    globalsignalgain=3.2;
    
applyzscore=globalappyzscore;
classifier=globalclassifier;
featuretype=globalfeaturetype;

downsize=1;timescale=1;amplitude=1;

% =====================================

% EEG(subject,trial,flash)
EEG = prepareEEG(Fs,windowsize,downsize,120,subjectRange,1:8,globalsignalgain,true,0);

% CONTROL
%EEG = randomizeEEG(EEG);

trainingRange = 1:nbofclassespertrial*15;

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

mpdict = wmpdictionary(64,'LstCpt',{{'wpsym4',2},'dct'});
           
                            
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
                
                if (timescale ~= 1 && false)
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


routput2=open('routput.mat');
routput2 = routput2.routput;

EEG2=open('EEG.mat')
EEG2=EEG2.EEG;

EEG2(8,2,1)

for i=1:12 
    %figure;plot( routput{8}{2}{1}{i}(:,7) )
    %title(sprintf('Label %d',EEG(8,2,i).label));
end


template1=routput2{8}{2}{1}{8};
template2=routput2{8}{2}{1}{1};


for i=1:43:256
    template1(i,:) = [];
    template2(i,:) = [];
end

figure;
plot(template1);axis([0 256 -10 10]);

EEG(21,2,9)
EEG(21,2,12)
EEG(21,2,11)

%% Sample Figure with ERP superimposed on EEG.
figure;
set(0, 'DefaultAxesFontSize',15);

for i=1:12
    t1 = routput{21}{2}{1}{i};


    subplot(2,6,i);
    plot(t1);
    hit=false;
    for s=1:12
        if (EEG(21,2,s).stim == i && EEG(21,2,s).label == 2)
            hit=true;
        end
    end
    
    if (hit)
        title('ERP');
    else
        title('Null');
    end    
    
    axis([0 256 -7 7]);
    set(gca,'XTick',[0 125 256]);
    set(gca,'XTickLabel',{'0','0.5','1.0'});
    ylabel('microV')
end
set(gcf, 'Position', [1, 1, 1055, 330])
figure;plot(routput{21}{2}{1}{3});axis([0 256 -10 10]);
figure;plot(routput{21}{2}{1}{9});axis([0 256 -10 10]);

%% ERP Dictionary
figure;
set(0, 'DefaultAxesFontSize',15);
counter=1;
for trial=1:15
    for i=1:12
        t1 = routput{21}{trial}{1}{i};
        
        for s=1:12
            if (EEG(21,trial,s).stim == i && EEG(21,trial,s).label == 2)
                subplot(5,6,counter);
                plot(t1);
                axis([0 256 -7 7]);
                set(gca,'XTick',[0 125 256]);
                set(gca,'XTickLabel',{'0','0.5','1.0'});
                counter=counter+1;
            end
        end  

    end
end
set(gcf, 'Position', [1, 1, 1055, 330])

%% ERP Queries
set(0, 'DefaultAxesFontSize',15);
for trial=16:35
    figure;
    cr = [];
    for i=1:12
        t1 = routput{21}{trial}{1}{i};
        
        subplot(2,6,i);
        plot(t1);
        axis([0 256 -17 17]);
        set(gca,'XTick',[0 125 256]);
        set(gca,'XTickLabel',{'0','0.5','1.0'}); 
        set(gcf, 'Position', [1, 1, 1055, 330])
        title(sprintf('%d',i));


        for s=1:12
        if (EEG(21,trial,s).stim == i && EEG(21,trial,s).label == 2)
            cr = [cr i];
        end
        end 

        
    end
    [trial-15 cr]
end
%%
% Component variability
%%
routput=open('routput.mat');
routput = routput.routput;

EEG=open('EEG.mat')
EEG=EEG.EEG;

EEG(8,2,1)

for i=1:12 
    %figure;plot( routput{8}{2}{1}{i}(:,7) )
    %title(sprintf('Label %d',EEG(8,2,i).label));
end



for i=1:10
template1=routput{8}{2}{1}{8};
template2=routput{8}{2}{1}{1};

reductionrate = randi(100,1,1)/100;

cutrange=37:249;

w = gausswin(size(template1(cutrange,:),1));
for ch=1:8
template1(cutrange,ch) = template1(cutrange,ch)-(template1(cutrange,ch)*reductionrate).*w;
end

figure;
plot(template1);
title('Multichannel ERP Template');
axis([0 256 -10 10]);
ylabel('Microvolts')
end

