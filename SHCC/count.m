function [fI]=count(matrix)
    len=6;
    [V,I]=sort(matrix(1:len));
    fI=[I(1)];
    b=0;
    i=2;
    while b==0
        if V(i)==V(1)
            fI=[fI;I(i)];
        else
            b=1;
        end
        if i==len
            b=1;
        end
        i=i+1;
    end
    
    
    