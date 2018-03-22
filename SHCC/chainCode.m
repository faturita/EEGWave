function [signal]=chainCode(tiempo,amplitud,ctipo,seg,print,name)
%tiempo = cputime;
%e1 = cputime-tiempo
%figure; plot(tiempo,amplitud);
if ctipo==0 %SCC
    [signal.tiempoNorm]=SHCC_normaliza(tiempo);
    [signal.amplitudNorm]=SHCC_normaliza(amplitud);
    [signal.tiempoSeg,signal.amplitudSeg]=SCC_segmentos(signal.tiempoNorm,signal.amplitudNorm,seg);
    [signal.chainSHCC,signal.tortuosidad,signal.angulos]=SCC_pendiente(signal.tiempoSeg,signal.amplitudSeg);
elseif ctipo==1%SHCC
    [signal.tiempoSeg,signal.amplitudSeg]=SHCC_segmentaCurva(tiempo,amplitud,seg);  
    signal.tiempoNorm=SHCC_normaliza(signal.tiempoSeg);
    signal.amplitudNorm=SHCC_normaliza(signal.amplitudSeg);
    [signal.chainSHCC,signal.tortuosidad,signal.angulos]=pendiente(signal.tiempoNorm,signal.amplitudNorm,print,print);
    %[signal.area,signal.areaBloques]=area(signal.tiempoNorm,signal.amplitudNorm);
elseif ctipo==2%Freeman
    [signal.chainSHCC,signal.tortuosidad,signal.angulos]=pendiente(tiempo,amplitud,print,print);
    signal.chainFreeman=Freeman(signal.angulos);
elseif ctipo==3%90grados
    [signal.tiempoSeg,signal.amplitudSeg]=SHCC_segmentaCurva(tiempo,amplitud,seg);  
    signal.tiempoNorm=SHCC_normaliza(signal.tiempoSeg);
    signal.amplitudNorm=SHCC_normaliza(signal.amplitudSeg);
    [signal.chainSHCC,signal.tortuosidad,signal.angulos]=pendiente(signal.tiempoSeg,signal.amplitudSeg,print,print);
    signal.chain90=grados90(signal.angulos);
end



