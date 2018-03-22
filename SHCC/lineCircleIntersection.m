%Objetivo: Obtener el punto en donde la l???nea interseca al circulo.
%Entrada:
%   x1,y1= Punto inicial de la recta que corta el circulo P1(x1,y1) 
%   x2,y2= Punto final de la recta que corta el circulo P2(x2,y2)
%   h,k=Centro del circulo
%Salida:
%   x,y= Punto de la recta que interseca el circulo
function [x,y]=lineCircleIntersection(x1,y1,x2,y2,h,k,r)
    %traslado al centro
%     x1=x1-h
%     y1=y1-k
%     x2=x2-h
%     y2=y2-k
    
    dx = x2-x1;
    dy = y2-y1;
    dr = sqrt(dx^2+dy^2);
    D = x1*y2-x2*y1;
    sn = sgn(dy);
    xra= (D*dy+sn*dx*sqrt(r^2*dr^2-D^2))/dr^2;
    xrb= (D*dy-sn*dx*sqrt(r^2*dr^2-D^2))/dr^2;
    yra= (-D*dx+abs(dy)*sqrt(r^2*dr^2-D^2))/dr^2;
    yrb= (-D*dx-abs(dy)*sqrt(r^2*dr^2-D^2))/dr^2;

    %Decidiendo el punto de la secante mas cercano a la curva   
     da2=sqrt((x2-xra)^2+(y2-yra)^2);
     db2=sqrt((x2-xrb)^2+(y2-yrb)^2);

    xra=xra+h;
    xrb=xrb+h;
    yra=yra+k;
    yrb=yrb+k;
    x2=x2+h;
    y2=y2+k;
    
    if da2 > db2
        x=xrb;
        y=yrb;
    else
        x=xra;
        y=yra;
    end
    v = sqrt((h-x)^2+(k-y)^2);
    [r v]
    v2= sqrt((h-x2)^2+(k-y2)^2)
    if (round(v*1000) > round(r*1000)) % | (round(v2*1000) < round(r*1000)) 
        x=x2;
        y=y2;
    end
    
    plot(xrb,yrb,'k*')
    plot(xra,yra,'y*')
    dibujaCirculo(x,y,r,150);
   