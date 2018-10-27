function EEG = DrugEEG(subjectRange,signalgain,EEG,randomdelay,randomamplitude)

for subject=subjectRange
    routput=open(sprintf('routput-subject-%0d.mat',subject));
    routput = routput.routput;

    EEGs=open(sprintf('EEG-%0d.mat',subject));
    EEGs=EEGs.EEG;  

    if (subject == 3)
        trial=8;class=12;
    elseif (subject == 4)
        trial=30;class=7;
    elseif (subject == 6)
        trial=2;class=4;
    elseif (subject == 7)
        trial=7;class=3;
    end

    template=routput{subject}{trial}{1}{class};
    
    cutrange=2:16;
    fullrange=1:16;

    w = gausswin(size(template(cutrange,:),1));
    wf = gausswin(size(template(fullrange,:),1));

    for trial=1:35
        for seq=1:120

            if (EEG(subject,trial,seq).label == 1)
                ti=randi(35);rep=randi(120);
                while (EEGs(subject,ti,rep).label==2)
                    ti=randi(35);rep=randi(120);
                end
                EEG(subject,trial,seq).EEG = EEGs(subject,ti,rep).EEG;           
                
            else

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
                    tt = zeros(size(template));

                    tt(1:end+delaylag,:) = t1(-delaylag+1:end,:);
                    t1=tt;
                end
                signalgain = 1;
                EEG(subject,trial,seq).EEG =  baseline;

            end
        end
    end
end

end