function [tiempoWarp,ERPprom]=templateDTW(tiempo,amplitud,seg,print)
    maxVolt=max(max(amplitud))   
    [a,b]=size(amplitud)    
    for i=1:a
        p300=limpiaP300(tiempo,amplitud(i,:),maxVolt)
        if ~isempty(p300)
            [tiempoSeg,amplitudSeg]=segmentaCurva(tiempo,amplitud(i,:),seg);
            [difpend,tortuosidad,m]=pendiente(tiempoSeg,amplitudSeg,print)
            
        end
        [Dist,D,k,w]=dtw(tiempoSeg,amplitudSeg,m)
            ERPprom=(tiempoSeg(w(:,1))+amlitudSeg(w(:,2)))./2;
            t=1:1:length(w);
    end