%Objetivo: Dibujar la curva.
%Entrada:
%   x_curva= Coordenadas x de la curva
%   y_curva= Coordenadas y de la curva
%   printpendiente= 1 indica que si hay que imprimir las pendientes 0 no
%Salida:
%   pendientes= Conjunto de pendientes entre un punto y otro de la curva

function [pendientes,tortuosidad,angulos]=pendiente(x_curva,y_curva,printpendiente,printtext)
    pendientes = [];
    codigo=[];
    if printpendiente==1
        title = 'Pendientes y diferencia de pendientes';
        figure;
        plot(x_curva(1),y_curva(1),'k.');
        hold on
    end
    
    for i=2:length(x_curva)
        
        x=x_curva(i);
        x_1=x_curva(i-1);
        y=y_curva(i);
        y_1=y_curva(i-1);
        
        if printpendiente==1
            plot(x,y,'k.');
        end
        
        if x>x_1
            lx=x_1:0.01:x;  
        else
            lx=x_1:-0.01:x;  
        end
        m = (y-y_1)/(x-x_1);
        pendientes = [pendientes m];
        ly=m*(lx-x_1) + y_1;
        
        if  fix(x*10000) == fix(x_1*10000)
            if y>y_1
                ly=y_1:0.0001:y;
            elseif y<y_1
                ly=y_1:-0.0001:y;
            end
            lx=ones(size(ly)).*x_1;
        else
            if x > x_1
                lx=x_1:0.0001:x;
            elseif x < x_1
                lx=x_1:-0.0001:x;
            end
            ly=m*(lx-x_1) + y_1;
        end
        if printpendiente
            plot(lx,ly,'k');
        end
        if printtext
            text(max(lx(300)),max(ly(100)),num2str(round(m)/100));
            %text(max(lx(300)),max(ly(100)),num2str(roundn(normalizaAlfabeto(m),-2)));
        end

    end
    angulos=rad2deg(atan(pendientes));
    %pendientes=roundn(normalizaAlfabeto(pendientes),-2);
pendientes=round(pendientes)/100;    
tortuosidad=sum(abs(pendientes));