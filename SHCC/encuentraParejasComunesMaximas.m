function [parejas_maximas]=encuentraParejasComunesMaximas(A,B)
parejas_maximas=[]
m=length(A)
for i=1:m
    if i==1
        parejas_maximas=encuentraPatronesMaximos(A(i:m),B,-1,i,parejas_maximas)
    else
        parejas_maximas=encuentraPatronesMaximos(A(i:m),B,A(i-1),i,parejas_maximas)
    end
end