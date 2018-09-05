function [ErrorPerChannel,SigmaPerChannel] = CrossValidatedSpellerPerformance(epochRange,subjectRange,SBJ,channelRange,papplyzscore,pclassifier,pfeaturetype,prandomdelay,prandomamplitude);

T=10;
KFolds=2;
E = zeros(T,size(channelRange,2));

for t=1:T

    kkfolds = fold(2, 1:35);
    kfolds = cell(1,2);
    for i=1:2
        for j=1:length(kkfolds{i})
            kfolds{i} = [kfolds{i} (kkfolds{i}(j)-1)*12+1:(kkfolds{i}(j)-1)*12+12];
        end
    end

    N = zeros(KFolds,1);
    EPs = zeros(KFolds,size(channelRange,2));    
    for f=1:KFolds

        trainingRange=defold(kfolds, f);
        testRange=kfolds{f};   
        
        for subject=subjectRange
            SBJ(subject).trainingRange = trainingRange;
            SBJ(subject).testRange = testRange;
        end

        spellingacc = doerpclassification(subjectRange,channelRange,SBJ,pclassifier);

    end
    for subject=subjectRange
        for channel=channelRange
            EPs(f,channel) = 1-spellingacc(subject,channel);
            E(t,subject,channel) = mean(EPs(:,channel));
        end
    end
end
for subject=subjectRange
    for channel=channelRange
        e= sum(E(:,subject,channel))/T;
        V = (sum((( E(:,subject,channel) - e ).^2)))  / (T-1);

        sigma = sqrt( V );

        ErrorPerChannel(subject,channel)=e;
        SigmaPerChannel(subject,channel)=sigma;        
    end
end

end