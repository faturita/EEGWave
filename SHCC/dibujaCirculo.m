%--------------------Graficar la circunferencia----------------------------
%Copyright (c) 2002, Zhenhai Wang
%All rights reserved.
%Entrada: 
%   x,y=Coordenadas del centro de la circunferencia
%   r=Radio de la circunferencia
%   N=Puntos en la circunferencia
%Salida:
%   Grafica de un circulo

function dibujaCirculo(x,y,r,N)

THETA=linspace(0,2*pi,N);
RHO=ones(1,N)*r;
[cX,cY] = pol2cart(THETA,RHO);
cX=cX+x;
cY=cY+y;
plot(cX,cY,'b.');
