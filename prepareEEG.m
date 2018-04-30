% EEG(subject,trial,flash)
function [EEG, labelRange, stimRange] = prepareEEG(Fs, windowsize, downsize, flashespertrial, subjectRange,channelRange,amplitude,bandpass,delaylag,randomdelay,randomamplitude)

artifactcount = 0;   

channels={ 'Fz'  ,  'Cz',    'P3' ,   'Pz'  ,  'P4'  , 'PO7'   , 'PO8',  'Oz'};
            
for subject=subjectRange
    clear data.y_stim
    clear data.y
    clear data.X
    clear data.trial

    load(sprintf('./signals/p300-subject-%02d.mat', subject));
data = DrugSignal(data,amplitude,delaylag,randomdelay,randomamplitude);
    dataX = data.X;
 dataX = notchsignal(data.X, channelRange,Fs);
    datatrial = data.trial;
time1=275222.343262227;
time2= 279948.995187305;
    %plotthiseeg(dataX,channels,channelRange,time1/1,time2/1,false);
    
    %dataX = filterbyica(dataX,[1 2]);
    
    %plotthiseeg(dataX,channels,channelRange,time1/1,time2/1,false);

    
    %dataX = filterbyica(dataX,[1 2]);

    if (bandpass)
        dataX = bandpasseeg(dataX, channelRange,Fs,3,true);
    end
    
    dataX = decimatesignal(dataX,channelRange,downsize); 
 %dataX = decimateaveraging(dataX,channelRange,downsize);
    %dataX = downsample(dataX,downsize);
    
    %l=randperm(size(data.y,1));
    %data.y = data.y(l);
     
    
       
    for trial=1:size(datatrial,2)
        for flash=1:flashespertrial
            
            % Mark this 12 repetition segment as artifact or not.
%             if (mod((flash-1),12)==0)
%                 iteration = extract(dataX, (ceil(data.trial(trial)/downsize)+64/downsize*(flash-1)),64/downsize*12);
%                 artifact=isartifact(iteration,70);
%             else
%                 artifact = false;
%             end         
            
            %EEG(subject,trial,flash).EEG = zeros((Fs/downsize)*windowsize,size(channelRange,2));

            
            start = data.flash((trial-1)*120+flash,1);
            duration = data.flash((trial-1)*120+flash,2);
            

            % Check overflow of the EEG matrix
            
            % Check overflow

            if (ceil(Fs/downsize)*windowsize>size(dataX,1)-ceil(start/downsize))
                dataX = [dataX; zeros(ceil(Fs/downsize)*windowsize-size(dataX,1)+ceil(start/downsize)+1,8)];
            end
            

%            output = baselineremover(dataX,ceil(start/downsize),ceil(Fs/downsize)*windowsize,channelRange,downsize);

            %output = baselineremover(dataX,ceil(start/downsize),ceil(Fs/downsize)*windowsize,channelRange,downsize);
            
            
%             output = baselineremover(dataX,ceil(start/downsize),...
%                 ceil((Fs/downsize)*windowsize),...
%                 channelRange,...
%                 downsize);

            
%             output = extract(dataX, ...
%                 (ceil(start/downsize)), ...
%                 ceil((Fs/downsize)*windowsize));

            
            output = extract(dataX, ...
                (ceil(start/downsize)), ...
                floor(Fs/downsize)*windowsize);
            
            
            %output=bf(output,1:5:size(output,2));
            
            
            %EEG(subject,trial,flash).label = data.y(start);
            %EEG(subject,trial,flash).stim = data.y_stim(start); 
            
            EEG(subject,trial,flash).stim = data.flash((trial-1)*120+flash,3);
            EEG(subject,trial,flash).label = data.flash((trial-1)*120+flash,4);
            
            [trial, flash, EEG(subject,trial,flash).stim, EEG(subject,trial,flash).label]
            
            EEG(subject,trial,flash).isartifact = false;
            artifact = isartifact(output,70);
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

end