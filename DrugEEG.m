function EEG = DrugEEG(subjectRange,EEG)

for subject=subjectRange
    routput=open(sprintf('routput-subject-%0d.mat',subject));
    routput = routput.routput;

    EEGs=open(sprintf('EEG-%0d.mat',subject));
    EEGs=EEG.EEG;  

    if (subject == 3)
        trial=8;class=12;
    elseif (subject == 4)
        trial=30;class=7;
    elseif (subject == 6)
        trial=2;class=4;
    elseif (subject == 7)
        trial=7;class=3;
    end

    t1=routput{subject}{trial}{1}{class};

    for trial=1:35
        for seq=1:120

            if (EEG(subject,trial,seq).label == 2)

                ti=randi(35);rep=randi(120);
                while (EEG(subject,ti,rep).label==2)
                    ti=randi(35);rep=randi(120);
                end
                t2 = EEG(subject,ti,rep).EEG;

                EEG(subject,trial,seq).EEG = t1 + t2;

            end
        end
    end
end

end