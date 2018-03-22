function X = DrugSignal(data,amplitude)

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

for subject=subjectRange
    clear data.y_stim
    clear data.y
    clear data.X
    clear dataX;
    clear data.trial
    load(sprintf('./signals/p300-subject-%02d.mat', subject));

    datatrial = data.trial;

    artifact = false;
    for trial=1:size(datatrial,2)
        for flash=1:flashespertrial
            
            start = data.flash((trial-1)*120+flash,1);
            duration = data.flash((trial-1)*120+flash,2);
            
            if (ceil(Fs/downsize)*windowsize>size(data.X,1)-ceil(start/downsize))
                data.X = [data.X; zeros(ceil(Fs/downsize)*10-size(data.X,1)+ceil(start/downsize)+1,8)];
            end   

            %output = extract(data.X, ...
             %   (ceil(start/downsize)), ...
              %  floor(Fs/downsize)*windowsize);
            
            stim = data.flash((trial-1)*120+flash,3);
            label = data.flash((trial-1)*120+flash,4); 

            if (label==2)
                data.X(start:start+(Fs*windowsize)-1,:) = data.X(start:start+(Fs*windowsize)-1,:)+template1(:,:)*amplitude;
            end
            
        end
    end
end
X = data.X;

end