function [countPos,countNeg]=PatronP300(chain,indMaxVolt)
len=length(chain);
countPos=0;
countNeg=0;
b=0;
ind=indMaxVolt;

if chain(ind)==-1
    countNeg=1;
    count=0;
    while b==0 & ind <= len
        ind=ind+1;
        if ind+2<len & chain(ind)==-1 & chain(ind+1)==1 & chain(ind+2)==1 & b==0
            countNeg=countNeg+1;
            b=1;
        end
        if ind+2<len & chain(ind)==-1 & chain(ind+1)==1 & chain(ind+2)==-1 & count==0 & b==0
            countNeg=countNeg+1;
            ind=ind+1;
            count=1;
        end
        if ind+1<len & chain(ind)==-1 & chain(ind+1)==1 & ind+2==len & count==0 & b==0
            countNeg=countNeg+1;
            ind=ind+1;
            count=1;
        end
        if ind < 1 | ind > len 
            b=1;
        end
        if b==0
            countNeg=countNeg+1;
        end
    end
    b=0;
    ind=indMaxVolt-1;
    countPos=0;
    count=0;
    if ind > 0
        if chain(ind)==-1
            ind=ind-1;
        end
        while b==0 & ind >= 1
            if ind-2>0 & chain(ind)==1 & chain(ind-1)==-1 & chain(ind-2)==-1 & b==0
                countPos=countPos+1;
                b=1;
            end
            if ind-2>1 & chain(ind)==1 & chain(ind-1)==-1 & chain(ind-2)==1 & count==0 & b==0
                countPos=countPos+1;
                ind=ind-1;
                count=1;
            end
            if ind-1>1 & chain(ind)==1 & chain(ind-1)==-1 & count==0 & b==0
                countPos=countPos+1;
                ind=ind-1;
                count=1;
            end
            if ind < 1 | ind > len 
                b=1;
            end
            if b==0
                countPos=countPos+1;
                ind=ind-1;
            end
        end
    end
else
    countPos=1;
    count=0;
    while b==0 & ind >= 1
        if ind-2>0 & chain(ind)==1 & chain(ind-1)==-1 & chain(ind-2)==-1 & b==0
            countPos=countPos+1;
            b=1;
        end
        if ind-2>1 & chain(ind)==1 & chain(ind-1)==-1 & chain(ind-2)==1 & count==0 & b==0
            countPos=countPos+1;
            ind=ind-1;
            count=1;
        end
        if ind-1>1 & chain(ind)==1 & chain(ind-1)==-1 & count==0 & b==0
            countPos=countPos+1;
            ind=ind-1;
            count=1;
        end
        if ind < 1 | ind > len 
            b=1;
        end
        if b==0
            countPos=countPos+1;
            ind=ind-1;
        end
    end
    b=0;
    ind=indMaxVolt+1;
    countNeg=1;
    count=0;
    while b==0 & ind <= len
        ind=ind+1;
        if ind+2<len & chain(ind)==-1 & chain(ind+1)==1 & chain(ind+2)==1 & b==0
            countNeg=countNeg+1;
            b=1;
        end
        if ind+2<len & chain(ind)==-1 & chain(ind+1)==1 & chain(ind+2)==-1 & count==0 & b==0
            countNeg=countNeg+1;
            ind=ind+1;
            count=1;
        end
        if ind+1<len & chain(ind)==-1 & chain(ind+1)==1 & ind+2==len & count==0 & b==0
            countNeg=countNeg+1;
            ind=ind+1;
            count=1;
        end
        if ind < 1 | ind > len 
            b=1;
        end
        if b==0
            countNeg=countNeg+1;
        end
    end   
    
end

    