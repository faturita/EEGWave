%Programa de Ernesto
function [x,y]=recibePendientes(pendientes)
    figure;
    
    pend=0;
    
    x=[];
    y=[];
    x(1)=0;
    y(1)=0;
    for i=1:length(pendientes)
       %pend=pend+pendientes(i);
       pend=pendientes(i);
       x=[x; x(i)+cos(pend*pi)];
       y=[y; y(i)+sin(pend*pi)];       
    end
    plot(x,y);
    axis equal