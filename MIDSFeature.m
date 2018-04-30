function [ar,locsremoved,feature] = MIDSFeature(signal,Ts,oa)

locations=1:size(signal,2);

sequences = MIDSSegment(signal);

sequences

%subplot(2,1,1);
%plot(sig);
%subplot(2,1,2);
%plot(a,sig(a));

for s=1:size(sequences,1)
    start=sequences(s,1);
    endv=sequences(s,2);
    
    % Importante que el max no tome los bordes del "wave" --> W, solo se
    % tiene que concentrar en el pico del medio.
    [wave,shift]=pickmaskedsignal(signal,start,endv,locations);
    [~,ai1] = max(wave(2:end-1));ai1=ai1+1;
    [~,ai] = min(wave(1:ai1));
    [~,ai2] = min(wave(ai1:end));ai2=ai2+ai1-1;

    ai3 = ai2+1;
    ai4 = ai3+1;

    t1 = bounded(signal,1,size(signal,2),start+shift(ai1)-1)-bounded(signal,1,size(signal,2),start+shift(ai)-1);
    t2 = bounded(signal,1,size(signal,2),start+shift(ai1)-1)-bounded(signal,1,size(signal,2),start+shift(ai2)-1);
    t3 = bounded(signal,1,size(signal,2),start+shift(ai3)-1)-bounded(signal,1,size(signal,2),start+shift(ai2)-1);
    t4 = bounded(signal,1,size(signal,2),start+shift(ai3)-1)-bounded(signal,1,size(signal,2),start+shift(ai4)-1);
    r=0.9;
    
    %figure;plot(signal);
    %figure;plot(wave);
    
    t = ai2-ai;  
    if ( (t < Ts*3/Ts) || ...
            (  (t1/t2 < r && t3/t4 < r) || ...
            (t2/t1 < r && t4/t3 < r) || ...
            (t2/t1 < r && t3/t4 < r) || ...
            ((t2/t1 < r && t3/t4 >=r) && (t4/t3 >= r && t2/t3 <= r)) || ...
            ((t3/t4 < r && t1/t2 >=r) && (t2/t1 >= r && t3/t2 <  r)) ...
            ) ...
        )
        [Sm,m] = max([bounded(signal,1,size(signal,2),start+shift(ai1)-1),bounded(signal,1,size(signal,2),start+shift(ai3)-1)]);
        if (m==1)
            if (start+shift(ai3)-1<=size(signal,2))
                locations(start+shift(ai3)-1) = 0;
                
                % En vez de eliminar el valor, voy a interpolar un nuevo
                % valor en basea a los dos del costado.
                
                %signal = boundedset(signal,1,size(signal,2),start+shift(ai3)-1, ...
                %    (bounded(signal,1,size(signal,2),start+shift(ai2)-1) + bounded(signal,1,size(signal,2),start+shift(ai4)-1))/2);
                
                
            end
        else
            if (start+shift(ai1)-1<=size(signal,2))
                locations(start+shift(ai1)-1) = 0;
                
                %signal = boundedset(signal,1,size(signal,2),start+shift(ai1)-1, ...
                %    (bounded(signal,1,size(signal,2),start+shift(ai)-1) + bounded(signal,1,size(signal,2),start+shift(ai2)-1))/2);
                
            end
        end        
    end
    
end

locsremoved=1:size(signal,2);
locsremoved(locations~=0) = [];
locations(locations==0) = [];

feature = signal(locations);

ar=oa(locations);

end


function sequences = MIDSSegment(sig)
dss = diff(sig);
ds = sign(dss);

ds

sequences = [];
state = 0;
% Divide in segments by analyzing the increasing and decreasing
% pattern with a finite automata.
% (-1) (1)+ (-1)
%         (1)   (-1)*  (1)
for j=1:size(ds,2)
    sample = ds(j);
    if (j==14)
        disp(j)
    end
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
                if ((sample==1) && (size(ds,2)>=j+1 && ds(j+1)==-1))
                    state = 2;
                end
            else
                state = 0;j=startj+1;startj=0;
            end
        case 2
            if (sample==-1)
                state = 3;
            else
                state = 0;j=startj+1;startj=0;
            end
        case 3
            if (sample==1)
                state = 4;
                if (j==size(ds,2))
                    ds(startj:j)
                    sequences = [sequences; [startj j+1]];
                    state = 0;startj=0; 
                end
            else
                state=3;
            end
        case 4
            ds(startj:j)
            sequences = [sequences; [startj j]];
            state = 0;startj=0;
    end
end

end