function EEG = DrugEEG(subjectRange,signalgain,EEG,randomdelay,randomamplitude)

for subject=subjectRange
    routput=open(sprintf('routput-subject-%0d.mat',subject));
    routput = routput.routput;

    EEGs=open(sprintf('EEG-%0d.mat',subject));
    EEGs=EEGs.EEG;  

    % Cherry-picking the best trial.
    if (subject == 3)
        trial=8;fls=12;
    elseif (subject == 4)
        trial=30;fls=7;
    elseif (subject == 6)
        trial=2;fls=4;
    elseif (subject == 7)
        trial=7;fls=3;
    end
    
    h=[];

    for trial=1:35
        for classes=1:1;for i=1:12 hit{subject}{trial}{classes}{i} = 0; end; end
        for flash=1:120
            hit{subject}{trial}{classes}{EEGs(subject,trial,flash).stim} = EEGs(subject,trial,flash).label;
        end
    end

    for trial=1:35
        for i=1:12
            if (hit{subject}{trial}{classes}{i} == 2)
                h = [h; [trial i]];
            end
        end
    end

    % Pick one
    p = randi(70);
    tr= h(p,1);
    fls= h(p,2);    
    

    template=routput{subject}{tr}{1}{fls};
    
    cutrange=2:16;
    fullrange=1:16;

    w = gausswin(size(template(cutrange,:),1));
    wf = gausswin(size(template(fullrange,:),1));

    for trial=1:35
        for seq=1:120

            if (EEG(subject,trial,seq).label == 2)
                ti=randi(35);rep=randi(120);
                while (EEGs(subject,ti,rep).label==2)
                    ti=randi(35);rep=randi(120);
                end
                baseline = EEGs(subject,ti,rep).EEG;
                            
                t1=template;
                
                if (randomamplitude)
                    reductionrate=randi(100,1)/100;

                    for ch=1:8
                        t1(cutrange,ch) = template(cutrange,ch)-(template(cutrange,ch)*reductionrate).*w;
                    end        
                end
                
                if (randomdelay)
                    delaylag = randi(floor(16*1*0.4),1,1)-floor(16*1*0.4);
                    %delaylag = -14;
                    tt = zeros(size(template));
                    var=7;
                    %tt = randi(var+1,size(template))-(var+2)/2;
                    %tt = baseline;
                    

                    if (delaylag<0)
                        tt(1:end+delaylag,:) = t1(-delaylag+1:end,:);
                    else
                        tt(1+delaylag:end,:) = t1(1:end-delaylag,:);
                    end
                    %tt(1,:) = 1; %randi(3)-2;
                    t1=tt;
                end
                EEG(subject,trial,seq).EEG = t1*signalgain + baseline;
            end
        end
    end
end

end