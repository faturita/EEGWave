function [p300]=limpiaP300(tiempo,amplitud)
p300=[];
maxVolt=max(max(amplitud))
[a,b]=size(amplitud)
for i=1:a
    %plot(tiempo,amplitud(i,:))
    [maxAmpl,t]=max(amplitud(i,:))
    if round(max(amplitud(i,:)))>=round(maxVolt)-3 & t>51 & t< 180
        p300=[p300; i]
    end
end
