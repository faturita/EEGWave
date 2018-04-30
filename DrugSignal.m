function data = DrugSignal(data,amplitude,delaylag, randomdelay, randomamplitude)

routput=open('routput.mat');
routput = routput.routput;

EEG=open('EEG.mat')
EEG=EEG.EEG;

EEG(8,2,1)

for i=1:12 
    %figure;plot( routput{8}{2}{1}{i}(:,7) )
    %title(sprintf('Label %d',EEG(8,2,i).label));
end


template1=routput{8}{2}{1}{8};
template2=routput{8}{2}{1}{1};


for i=1:43:256
    template1(i,:) = [];
    template2(i,:) = [];
end

Fs=250;
          
flashespertrial=120;
downsize=1;

subject=21;
subjectRange=subject;

windowsize=1;

fullrange=1:250;
cutrange=37:249;

w = gausswin(size(template1(cutrange,:),1));
wf = gausswin(size(template1(fullrange,:),1));

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
        
        t1 = template1;
         
        if (randomamplitude)
            reductionrate=randi(100,1)/100;
        
            for ch=1:8
                t1(cutrange,ch) = template1(cutrange,ch)-(template1(cutrange,ch)*reductionrate).*w;
            end        
        end
        
        if (label==2)
            data.X(start:start+(Fs*windowsize)-1,:) = data.X(start:start+(Fs*windowsize)-1,:)+template1(:,:)*amplitude;
            for ch=1:8
                %template1(cutrange,ch) = template1(cutrange,ch)-(template1(cutrange,ch)*0.9).*w;
                %data.X(start-delaylag:start+(Fs*windowsize)-delaylag-1,ch) = data.X(start-delaylag:start+(Fs*windowsize)-delaylag-1,ch) + (t1(fullrange,ch)*amplitude).*wf;
            end
        end

    end
end

end