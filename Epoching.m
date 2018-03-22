%%
clear mex
clc
clear
clearvars
close all

windowsize=1;
downsize=10;
imagescale=4;
timescale=4;
amplitude=3;
sqKS=[50];
siftscale=[4 4];
siftdescriptordensity=1;
minimagesize=floor(sqrt(2)*15*siftscale(2)+1);
nbofclassespertrial=12;
k=7;
adaptative=false;
subjectRange=[1 2 3 4 6 7 8 9 10 11 14 15 16 17 18 19 20 21 22 23];
subjectRange=[1 11 14   16 17 20 22 23];

subjectRange=[21]

Trials=35;
Fs=250;

downsize=1;

%EEG = prepareEEG(Fs,windowsize,downsize,120,subjectRange,1:8);
EEG = prepareEEG(Fs,1,1,120,subjectRange,1:8);

Fs=Fs/downsize;
for i=1:12 rcounter{i} = 0; end

for subject=subjectRange
    for trial=1:Trials
        for flash=1:120
            rcounter{EEG(subject,trial,flash).stim} = rcounter{EEG(subject,trial,flash).stim}+1;
        end
    end
end

% Epoching
for subject=subjectRange
    globalnumberofsamples=1200000;
    globalnumberofepochs=12000000;
    routput = [];
    boutput = [];
    rcounter = 0;
    bcounter = 0;
    processedflashes = 0;
    
    
    epoch=0;
    for trial=1:Trials
        %routput = [];
        %boutput = [];
        %rcounter = 0;
        %bcounter = 0;
        %processedflashes = 0;
        for flash=1:120
            
            % Process one epoch if the number of flashes has been reached.
            if (processedflashes>globalnumberofsamples)
                break;
                %SignalAveragingProcessingSegment;
                %processedflashes=0;
            end
            
            % Skip artifacts
            if (EEG(subject,trial,flash).isartifact)
                continue;
            end
            
            
            %             if (mod(flash-1,12)==0)
            %                 assert( globalnumberofepochs>2 ||  processedflashes==0 || bcounter==1);
            %                 bcounter=0;
            %                 rcounter=0;
            %                 bpickercounter = 0;
            %                 bwhichone = [0 1];%bwhichone=sort(randperm(10,2)-1);
            %             end
            
            label = EEG(subject,trial,flash).label;
            output = EEG(subject,trial,flash).EEG;
            
            processedflashes = processedflashes+1;
            
            if ((label==2) && (rcounter<globalnumberofepochs))
                routput = [routput; output];
                rcounter=rcounter+1;
            end
            if ((label==1) && (bcounter<globalnumberofepochs))
                boutput = [boutput; output];
                bcounter=bcounter+1;
            end
            
        end
    end
    
    channelRange=1:8;
    channels={ 'Fz'  ,  'Cz',    'P3' ,   'Pz'  ,  'P4'  , 'PO7'   , 'PO8',  'Oz'};
    
    %%
    if (size(routput,1) >= 2)
        %assert( bcounter == rcounter, 'Averages are calculated from different sizes');
        
        %assert( size(boutput,1) == size(routput,1), 'Averages are calculated from different sizes.')
        
        assert( (size(routput,1) >= 2 ), 'There arent enough epoch windows to average.');
        
        routput=reshape(routput,[Fs size(routput,1)/Fs 8]);
        boutput=reshape(boutput,[Fs size(boutput,1)/Fs 8]);
        
        for channel=channelRange
            rmean(:,channel) = mean(routput(:,:,channel),2);
            bmean(:,channel) = mean(boutput(:,:,channel),2);
        end
        
        subjectaverages{subject}.rmean = rmean;
        subjectaverages{subject}.bmean = bmean;
        
    end
    
    %%
    fig = figure(subject);
    
    for channel=1:8
        rmean = subjectaverages{subject}.rmean;
        bmean = subjectaverages{subject}.bmean;
        
        %[n,m]=size(rmean);
        %rmean=rmean - ones(n,1)*mean(rmean,1);
        
        %[n,m]=size(bmean);
        %bmean=bmean - ones(n,1)*mean(bmean,1);
        
       
        
        subplot(4,2,channel);
        
        hold on;
        Xi = 0:0.1:size(rmean,1);
        Yrmean = pchip(1:size(rmean,1),rmean(:,channel),Xi);
        Ybmean = pchip(1:size(rmean,1),bmean(:,channel),Xi);
        plot(Xi,Yrmean,'r','LineWidth',2);
        plot(Xi,Ybmean,'b--','LineWidth',2);
        %plot(rmean(:,2),'r');
        %plot(bmean(:,2),'b');
        axis([0 Fs -6 6]);
        set(gca,'XTick', [Fs/4 Fs/2 Fs*3/4 Fs]);
        set(gca,'XTickLabel',{'0.25','.5','0.75','1s'});
        set(gca,'YTick', [-5 0 5]);
        set(gca,'YTickLabel',{'-5 uV','0','5 uV'});
        set(gcf, 'renderer', 'opengl')
        %hx=xlabel('Repetitions');
        %hy=ylabel('Accuracy');
        set(0, 'DefaultAxesFontSize',18);
        text(0.5,4.5,sprintf('Channel %s',channels{channel}),'FontWeight','bold');
        %set(hx,'fontSize',20);
        %set(hy,'fontSize',20);
    end
    legend('Target','NonTarget');
    hold off
end