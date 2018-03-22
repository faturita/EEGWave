artifactcount = 0;  
amplification=1;
          
flashespertrial=120;
downsize=15;

subject=21;
subjectRange=subject;

windowsize=1;

downsize=15;

for subject=subjectRange
    clear data.y_stim
    clear data.y
    clear data.X
    clear dataX;
    clear data.trial
    load(sprintf('./signals/p300-subject-%02d.mat', subject));
    data.X = DrugSignal(data,10);

    dataX = notchsignal(data.X, channelRange,Fs);

    datatrial = data.trial;
    
    time1=data.flash(4,1)/Fs;
    time2=data.flash(4,1)/Fs+windowsize*5;
    plotthiseeg(dataX,channels,channelRange,time1,time2,Fs,false);

    %dataX = decimateaveraging(dataX,channelRange,downsize);
    dataX = bandpasseeg(dataX, channelRange,Fs,3);
    dataX = decimatesignal(dataX,channelRange,downsize);
    %dataX = downsample(dataX,downsize);
    
    plotthiseeg(dataX,channels,channelRange,time1,time2,Fs/downsize,false);
    
    %l=randperm(size(data.y,1));
    %data.y = data.y(l);
       
    artifact = false;
    for trial=1:size(datatrial,2)
        for flash=1:flashespertrial
            
            start = data.flash((trial-1)*120+flash,1);
            duration = data.flash((trial-1)*120+flash,2);
            
            if (ceil(Fs/downsize)*windowsize>size(dataX,1)-ceil(start/downsize))
                dataX = [dataX; zeros(ceil(Fs/downsize)*windowsize-size(dataX,1)+ceil(start/downsize)+1,8)];
            end            
            
            % Mark this 12 repetition segment as artifact or not.
            if (mod((flash-1),12)==0)
                if (ceil(Fs/downsize*windowsize)*12>size(dataX,1)-ceil(start/downsize))
                    dataX = [dataX; zeros(ceil(Fs/downsize*windowsize)*12-size(dataX,1)+ceil(start/downsize)+1,8)];
                end                 
                iteration = extract(dataX, ...
                     (ceil(start/downsize)), ...
                     (Fs/downsize)*windowsize*12);
                artifact=isartifact(iteration,70);  
            end         
            
            %EEG(subject,trial,flash).EEG = zeros((Fs/downsize)*windowsize,size(channelRange,2));
            

            
            output = baselineremover(dataX,...
                ceil(start/downsize),...
                floor((Fs/downsize)*windowsize),...
                channelRange,...
                downsize);

            output = extract(dataX, ...
                (ceil(start/downsize)), ...
                floor(Fs/downsize)*windowsize);
            
            
            EEG(subject,trial,flash).stim = data.flash((trial-1)*120+flash,3);
            EEG(subject,trial,flash).label = data.flash((trial-1)*120+flash,4); 
            
            [trial, flash, EEG(subject,trial,flash).stim, EEG(subject,trial,flash).label]
            
            EEG(subject,trial,flash).isartifact = false;
            if (artifact)
                artifactcount = artifactcount + 1;
                EEG(subject,trial,flash).isartifact = true;
            end
            
            % This is a very important step, do not forget it.
            % Rest the media from the epoch.
            [n,m]=size(output);
            output=output - ones(n,1)*mean(output,1); 
            
            %output = zscore(output)*2;      

            EEG(subject,trial,flash).EEG = output;

        end
    end
end

figure;
plot(data.X);
title('Experimento P300, 1433 s, 7 palabras de 5 letras, 120 repeticiones');
ylabel('[microV]');
xlabel('[ms]');



%%
figure;
for i=1:4200
    if (data.flash(i,4)==2)
        time1=data.flash(i,1)/(Fs);
        time2=data.flash(i,1)/(Fs)+windowsize*5;
        plotthiseeg(dataX,channels,channelRange,time1,time2,Fs/downsize,false);
        pause;
        close all;
    end
end
fdfds

%%
figure
hold on
for c=channelRange
    %plot(data.X(275222:277948,c)+c*100);
    plot(data.X(:,c)+c*100);
end
legend(channels);
title('Experimento P300, 1433 s, 7 palabras de 5 letras, 120 repeticiones');
ylabel('[microV]');
xlabel('[ms]');
hold off
   
   
%%

fprintf('Primer segmento a analizar artifactos\n');
time1=275222.343262227;
time2= 277948.995187305;


figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
hold on
% Create multiple lines using matrix input to plot
for c=channelRange
    plot(data.X(:,c)+c*100,'Parent',axes1);
end
xlim(axes1,[time1 time2]);
%ylim(axes1,[-103.606833529613 119.258061149953]);
title('Captura multicanal a partir de 275222 1100s, de 10.9040 s');
ylabel('[microV]');
xlabel('[ms]');
legend(channels)
hold off


%%
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
hold on
% Create multiple lines using matrix input to plot
for c=channelRange
    plot(dataX(:,c)+c*100,'Parent',axes1);
end
xlim(axes1,[time1/downsize time2/downsize]);
%ylim(axes1,[-103.606833529613 119.258061149953]);
title('Captura multicanal a partir de 275222 1100s, de 10.9040 s');
ylabel('[microV]');
xlabel('[ms]');
legend(channels)
hold off

%%
    % Ojo que reduce los canales... e FASTICA los invierte.
    %output = fastica(output');
    
     %output = output';
    
[coeff, score, latent] = princomp(data.X);

cumsum(latent)./sum(latent)
    
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
hold on
% Create multiple lines using matrix input to plot
for c=channelRange
    plot(score(:,c)*amplification+c*100,'Parent',axes1);
end
xlim(axes1,[time1 time2]);
%ylim(axes1,[-103.606833529613 119.258061149953]);
title(sprintf('PCA multicanal a partir de %10.2f %10.2f s, de 10.9040 s de largo',time1,time1/Fs));
ylabel('[microV]');
xlabel('[ms]');
legend(channels)
hold off    

[output, A, W] = fastica(data.X');
    
icas = output';


figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
hold on
% Create multiple lines using matrix input to plot
for c=channelRange
    plot(icas(:,c)*10+c*100,'Parent',axes1);
end
xlim(axes1,[time1 time2]);
%ylim(axes1,[-103.606833529613 119.258061149953]);
title(sprintf('ICA multicanal a partir de %10.2f %10.2f s, de 10.9040 s de largo',time1,time1/Fs));
ylabel('[microV]');
xlabel('[ms]');
legend(channels)
hold off  


WW = inv(W);
icas(:,1) = zeros(size(icas,1),1);
icas(:,2) = zeros(size(icas,1),1);
eeg = WW * icas';
eeg=eeg';


figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
hold on
% Create multiple lines using matrix input to plot
for c=channelRange
    plot(eeg(:,c)+c*100,'Parent',axes1);
end
xlim(axes1,[time1 time2]);
%ylim(axes1,[-103.606833529613 119.258061149953]);
title('ICA FILTRO multicanal a partir de 275222 1100s, de 10.9040 s');
ylabel('[microV]');
xlabel('[ms]');
legend(channels)
hold off

%%
fprintf('Extraccion de baseline para identificacion del p300 single trial\n');
time1=346774.193548387;
time2=348774.774193548;

figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
hold on
% Create multiple lines using matrix input to plot
for c=channelRange
    plot(data.X(:,c)+c*100,'Parent',axes1);
end
xlim(axes1,[time1 time2]);
%ylim(axes1,[-103.606833529613 119.258061149953]);
title(sprintf('Captura multicanal a partir de %10.2f %10.2f s, de 10.9040 s de largo',time1,time1/Fs));
ylabel('[microV]');
xlabel('[ms]');
legend(channels)
hold off

%%
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
hold on
% Create multiple lines using matrix input to plot
for c=channelRange
    plot(dataX(:,c)+c*100,'Parent',axes1);
end
xlim(axes1,[time1/downsize time2/downsize]);
%ylim(axes1,[-103.606833529613 119.258061149953]);
title(sprintf('Captura multicanal decimada x 10 a partir de %10.2f %10.2f s, de 10.9040 s de largo',time1,time1/Fs));ylabel('[microV]');
xlabel('[ms]');
legend(channels)
hold off


%%
amplification=1;
dtt=4086;
dtt=4089;
for dtt=120*34:120*35
    if (targets(dtt,2)==2)
        targets(dtt,:)
        targets(120*34+6,:);
        stimulations(120*34+6,:);
        EEG(1,35,6);

        time1=targets(dtt,1)*Fs;
        time2=targets(dtt,1)*Fs+Fs;

        %plotthiseeg(data.X,channels,channelRange,time1,time2,false);

        plotthiseeg(dataX,channels,channelRange,time1/downsize,time2/downsize,true);

        %plotthiseeg(dataX,channels,channelRange,time1/downsize,time2/downsize,false);

    end
end

%figure;
%plot(EEG(1,35,6).EEG)


%%
for i=1:size(data.flash,1)-1
    a = data.flash(i,1);
    b=  data.flash(i,2);
    assert( (a+b)<= data.flash(i+1,1), 'overlapping');
end

