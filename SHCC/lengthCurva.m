%Objetivo: Obtiene suma de la distancia euclidiana entre los puntos que 
%conforman la curva.
%Entrada:
%   x_curva= Coordenadas x de la curva
%   y_curva= Coordenadas y de la curva
%Salida:
%   sizeCurve= Longitud de la curva
function [sizeCurve]=lengthCurva(x,y)
    st = 0;
    sizeCurve = [];
    max=length(x);
    for i=2:max
        st = st + sqrt((x(i)-x(i-1))^2+(y(i)-y(i-1))^2);
        sizeCurve = [sizeCurve st];
    end 