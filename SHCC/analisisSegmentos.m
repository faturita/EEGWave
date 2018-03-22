
analizados=205
sujetos=0
for j=1:2:44
    sujetos=sujetos+1
    prom=[];
    stdev=[];
    for i=2:analizados
        prom=[prom; eval(['seg' num2str(i) '(' num2str(j) ',:)'])];
        stdev=[stdev; eval(['seg' num2str(i) '(' num2str(j+1) ',:)'])];
    end
    for i=1:7
        h=figure('visible','on'); 
        errorbar(prom(:,i)',stdev(:,i)')
        set(gca,'XLim',[0 206])
        set(gca,'XTick',[0:10:206])
        set(gcf,'Color','white')
        saveas(h,['parametro_numSeg/sujeto' int2str(sujetos) '_electrodo' int2str(i) '.jpg'])
    end
end
