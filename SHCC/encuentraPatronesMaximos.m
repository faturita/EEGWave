function [parejas_maximas]=encuentraPatronesMaximos(A,B,elemento_anterior,indx,parejas_maximas) 
n=length(B)
for i=1:n-1
    [B(i) ' ' A(1)]
    [B(i+1) ' ' A(2)]
    if (B(i)==A(1)) & (B(i+1)==A(2))
        if (elemento_anterior~=-1) & (i~=1) & (B(i-1)==elemento_anterior)
            ind=encuentraIndiceMaximo(A,B(i:n))
            m=A(indx:ind) 
            B(i:ind)
            parejas_maximas=[parejas_maximas; m]
        end
    end
end