function newsignal=linearfillmissingvalues(signal,a)
    
    a(end+1) = size(signal,2);
    a(end+1) = size(signal,2)+1;
    
    newsignal=zeros(1,size(signal,2));
    min=1;max=20;

    for i=1:size(a,2)-1
        dif = a(i+1)-a(i);

        newsignal(a(i)) = signal(a(i));

        if (dif>1)
            step = (signal(a(i+1))-signal(a(i)) ) / dif;
            for s=1:dif-1
                newsignal(a(i)+s) = signal(a(i))+step*s;
            end
        end
    end
end