% Signal Averaging x Selection g.Tec Dataset.

% run('/Users/rramele/work/vlfeat/toolbox/vl_setup')
% run('D:/workspace/vlfeat/toolbox/vl_setup')
% run('C:/vlfeat/toolbox/vl_setup')
% P300 for Healthy Subjects.

clear globalspeller
clear globalaccij1
clear globalaccij2

rng(396545);

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
subjectRange=[3,4,6,7];
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

featuretype=4; classifier=4; applyzscore=true;
timescale=1; amplitude=1;artifactcheck=true;


%downsize=1;timescale=1;amplitude=1;

% =====================================

% EEG(subject,trial,flash)
EEG = prepareEEG(Fs,windowsize,downsize,120,subjectRange,1:8,globalsignalgain,true,false,0,false,false);

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
    save(sprintf('routput-subject-%0d.mat',subject),'routput');
    save(sprintf('EEG-%0d.mat',subject),'EEG');
end




fdsfds
%%
figure;
hold on
for r=1:6
    subplot(2,6,r);plot( routput{subject}{1}{1}{r} );
end
for c=7:12
    subplot(2,6,c);plot( routput{subject}{1}{1}{c} );
end

hold off



%%
%% Sample Figure with ERP superimposed on EEG.
subject=3;
for trial=1:35
    figure;
    set(0, 'DefaultAxesFontSize',15);

    for i=1:12
        t1 = routput{subject}{trial}{1}{i};


        subplot(2,6,i);
        plot(t1);
        hit=false;
        for s=1:12
            if (EEG(subject,trial,s).stim == i && EEG(subject,trial,s).label == 2)
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
    %figure;plot(routput{subject}{2}{1}{3});axis([0 256 -10 10]);
    %figure;plot(routput{subject}{2}{1}{9});axis([0 256 -10 10]);
end

fsd
%%
artifactcount = 0;   
randomdelay=false;
randomamplitude=false;
delaylag=0;

channels={ 'Fz'  ,  'Cz',    'P3' ,   'Pz'  ,  'P4'  , 'PO7'   , 'PO8',  'Oz'};
            
for subject=subjectRange
    clear data.y_stim
    clear data.y
    clear data.X
    clear data.trial

    load(sprintf('./signals/p300-subject-%02d.mat', subject));
    
templatesi=routput{3}{8}{1}{12};
templateno=routput{3}{19}{1}{3};


Fs=250;
          
flashespertrial=120;
downsize=1;

windowsize=1;

fullrange=1:250;
cutrange=37:249;

w = gausswin(size(templatesi(cutrange,:),1));
wf = gausswin(size(templatesi(fullrange,:),1));

datatrial = data.trial;

artifact = false;
for trial=1:size(datatrial,2)
    for flash=1:flashespertrial

        start = data.flash((trial-1)*120+flash,1);
        duration = data.flash((trial-1)*120+flash,2);

        if (ceil(Fs/downsize)*windowsize>size(data.X,1)-ceil(start/downsize))
            data.X = [data.X; zeros(ceil(Fs/downsize)*10-size(data.X,1)+ceil(start/downsize)+1,8)];
            data.y = [data.y; zeros(ceil(Fs/downsize)*10-size(data.y,1)+ceil(start/downsize)+1,1)];
            data.y_stim = [data.y_stim; zeros(ceil(Fs/downsize)*10-size(data.y_stim,1)+ceil(start/downsize)+1,1)];
        end   

        %output = extract(data.X, ...
         %   (ceil(start/downsize)), ...
          %  floor(Fs/downsize)*windowsize);

        stim = data.flash((trial-1)*120+flash,3);
        label = data.flash((trial-1)*120+flash,4); 
        
        if (randomdelay)
            delaylag = randi(floor(Fs*windowsize*0.4),1,1)-floor(Fs*windowsize*0.4);
        end
        
        t1 = templatesi;
        
        ti=randi(35);rep=randi(120);
        while (EEG(subject,ti,rep).label==2)
            ti=randi(35);rep=randi(120);
        end
        t2 = EEG(3,ti,rep).EEG;
         
        if (randomamplitude)
            reductionrate=randi(100,1)/100;
        
            for ch=1:8
                t1(cutrange,ch) = templatesi(cutrange,ch)-(templatesi(cutrange,ch)*reductionrate).*w;
                t2(cutrange,ch) = t2(cutrange,ch)-(t2(cutrange,ch)*reductionrate).*w;
            end        
        end
        
        if (label==2)
            %data.X(start:start+(Fs*windowsize)-1,:) = data.X(start:start+(Fs*windowsize)-1,:)+template1(:,:)*amplitude;
            for ch=1:8
                %template1(cutrange,ch) = template1(cutrange,ch)-(template1(cutrange,ch)*0.9).*w;
                %data.X(start-delaylag:start+(Fs*windowsize)-delaylag-1,ch) = data.X(start-delaylag:start+(Fs*windowsize)-delaylag-1,ch) + (t1(fullrange,ch)*amplitude).*wf;
%                 data.X(start-delaylag:start+(Fs*windowsize)-delaylag-1,ch) = ...
%                     data.X(start-delaylag:start+(Fs*windowsize)-delaylag-1,ch) + ...
%                     (t1(fullrange,ch)*amplitude);
                 data.X(start-delaylag:start+(Fs*windowsize)-delaylag-1,ch) = ...
                    t2(fullrange,ch) + ...
                    (t1(fullrange,ch)*amplitude);
            
            end
        end

    end
end
end


%%
time1=275222.343262227;
time2= 279948.995187305;
trial=1;flash=1;
start = data.flash((trial-1)*120+flash,1);
duration = data.flash((trial-1)*120+flash,2);
plotthiseeg(data.X,channels,channelRange,(start)/Fs,(start+250)/Fs,Fs,true);
