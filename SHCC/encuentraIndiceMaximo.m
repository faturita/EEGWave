function [indice]=encuentraIndiceMaximo(A,B)
m=length(A)
n=length(B)
indice=1
while (indice <= m) & (indice<=n) & (A(indice)==B(indice))
    indice=indice+1;
end
