%Objetivo:  Dividir la curva en segmentos de linea.
%Parametros de entrada: 
%  x,y=Vectores de coordenadas de los puntos que conforman la curva.
%  segmentos=Numero de segmentos en los que se debe dividir la curva. 
%Parametros de salida:
%   xb,yb= Vectores de coordenadas de los puntos que conforman la curva
%   discretizada.
%Nota: El c?digo es muy sensible al muestreo. Si no hay una buena
%interpolaci?n, falla.


function [xb,yb]=SCC_segmentos(xi,yi,segmentos)
    %figure;
    %axis equal
    %hold on
    %x = (0:.0035:1)';%normalizado
    x = (0:3:800)';
    y = interp1q(xi',yi',x);
    %x=xi;y=yi;
    %plot(x,y,'*');
    
    max=length(x);
    s=0;
    sb=0;
    %Obtiene el tamanio de los segmentos
    sizeCurve=lengthCurva(x,y,max);
    sizeCurve=sizeCurve(length(sizeCurve));
    
    r = sizeCurve/segmentos; %Para los puntos q no inician con cero
    xb=x(1);
    yb=y(1);
    %plot(x(1),y(1),'*r')
    %hold all;
    for i=2:max
        s = s + sqrt((x(i)-x(i-1))^2+(y(i)-y(i-1))^2);
        if s >= r
            %plot(x(i),y(i),'*r')
            xb=[xb; x(i)];
            yb=[yb; y(i)];
            sb=[sb; s];
            s=0;
        end     
    end 
    if length(xb)==segmentos
        %plot(x(max),y(max),'*r')
        xb=[xb; x(max)];
        yb=[yb; y(max)];
    end
    %sb
    %plot(xb,yb)
    
        
      