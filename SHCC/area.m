%Trapezoidal numerical integration
function [sarea,da]=area(tiempo,amplitud)
    len=16;
    dx=[];
    dy=[];
    for i=2:len
tiempo
i
        dx=[dx tiempo(i)-tiempo(i-1)];
        dy=[dy 0.5*(amplitud(i)+amplitud(i-1))];
    end
    da=dx.*dy;
    trapz(tiempo,amplitud);
    sarea=sum(da);
    
        