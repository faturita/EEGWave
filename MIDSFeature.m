function [a,b,feature] = MIDSFeature(sig,Ts)

a=1:size(sig,2);

sequences = MIDSSegment(sig);

subplot(2,1,1);
plot(sig);
subplot(2,1,2);
plot(a,sig(a));


for s=1:size(sequences,1)
    f=sequences(s,1);
    e=sequences(s,2);
    signal=sig(f:e);
    [~,ai1] = max(signal);
    [~,ai] = min(signal(1:ai1));
    [~,ai2] = min(signal(ai1:end));ai2=ai2+ai1;
    ai3 = ai2+1;

    %ai=ai1-1;
    %ai2=ai1+1;

    t = ai2-ai;
    if (t > 200/Ts || true)
        F=[ai1, ai3];
        [Sm,m] = max([sig(f+ai1),sig(f+ai3)]);
        if (m==1)
            a(f+ai2) = 0;
            a(f+ai3) = 0;
            f+ai2+1
        else
            a(f+ai1) = 0;
            a(f+ai2) = 0;
            f+ai2+1
        end
    end
    
end

for s=1:size(sequences,1)
    f=sequences(s,1);
    e=sequences(s,2);
    [signal,shift]=pickmaskedsignal(sig,f,e,a);
    [~,ai1] = max(signal);
    [~,ai] = min(signal(1:ai1));
    [~,ai2] = min(signal(ai1:end));ai2=ai2+ai1;

    %ai=ai1-1;
    %ai2=ai1+1;
    ai3 = ai2+1;
    ai4 = ai3+1;

    t1 = ai1-ai;
    t2 = ai1-ai2;
    t3 = ai3-ai2;
    t4 = ai3-ai4;
    r=0.5;
    
       
    if (    (t1/t2 < r && t3/t4 < r) || ...
            (t2/t1 < r && t4/t3 < r) || ...
            (t2/t1 < r && t3/t4 < r) || ...
            ((t2/t1 < r && t3/t4 >=r) && (t4/t3 >= r && t2/t3 <= r)) || ...
            ((t3/t4 < r && t1/t2 >=r) && (t2/t1 >= r && t3/t2 <  r)) ...
            || true)
        F=[ai1, ai2+1];
        [Sm,m] = max([sig(f+shift(ai1)),sig(f+shift(ai2+1))]);
        if (m==1)
            a(f+shift(ai3)) = 0;
            f+ai3
        else
            a(f+shift(ai1)) = 0;
            f+ai1
        end        
    end
    
end

b=1:120;
b(a~=0) = [];
a(a==0) = [];

feature = sig(a);

end


function sequences = MIDSSegment(sig)
dss = diff(sig);
ds = sign(dss);

sequences = [];
state = 0;
% Divide in segments by analyzing the increasing and decreasing
% pattern with a finite automata.
% (-1) (-1)+ (-1)
%           (1)   (-1)*  (1)
for j=1:size(ds,2)
    sample = ds(j);
    switch (state)
        case 0
            if (sample==-1) 
                state = 1;
                startj = j;
            else 
                state = 0;startj=0;
            end
        case 1
            if (sample==1) || (sample==0)
                state = 1;
                if ((sample==1) && ds(j+1)==-1)
                    state = 2;
                end
            else
                state = 0;startj=0;
            end
        case 2
            if (sample==-1)
                state = 3;
            else
                state = 0;startj=0;
            end
        case 3
            if (sample==1 || sample==0)
                state = 4;
            else
                state = 0;startj=0;
            end
        case 4
            ds(startj:j)
            sequences = [sequences; [startj j]];
            state = 0;startj=0;
    end
end

end