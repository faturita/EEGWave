function [letras]=detectaSimbolo(ruta_calibracion,ruta_clasificacion,ruta_Datos,sujeto, seg)

dtipo=1; %%%1=L1;2=Frechet;3=LCS
mtipo=1; %%%1=P2P;2=Woody;3=DTW
ctipo=1; %%%0=SCC;1=SHCC;2=Freeman45;3=90grados

NumMatrixRows = 6;
NumMatrixColumns = 6;

%Obtiene datos
load(strcat(ruta_calibracion,sujeto,'/calibracion.mat'));
%[ERPgral,etiqGral,t]=abreArchivosValida(sujeto); 
[dataCalor,dataCarino,dataSushi,etiqCalor,etiqCarino,etiqSushi,t]=abreArchivosCalib(ruta_Datos);
ERPgral=[dataCalor;dataCarino;dataSushi];
etiqGral=[etiqCalor; etiqCarino; etiqSushi];


Code=etiqGral(:,3); %Code=[900x1] Filas y columnas intensificadas
etiqGral(find(etiqGral(:,2)==-1),2)=0;%cambio -1 por 0, nom?s
Type=etiqGral(:,2);
choices=NumMatrixRows+NumMatrixColumns;
epoch = choices*bestT;%12 letras*15 intensificaciones para analizar una letra
num_letras=length(ERPgral)/epoch;
letras=[];
lenCh=length(bestCH);
lenF=[];
krow=0;
kcol=0;
ini=1;
for i=1:num_letras
    lenR=[];
    lenC=[];
    
    %Separa las letras
    fin=epoch*i;
    range=ini:fin';
    ini=fin+1;

    %Que fila y columna se espera que el sujeto elija 
    codes=unique(Code(range).*Type(range));
    coderow(i)=codes(2);
    if length(codes)>2
        codecol(i)=codes(3);
    end
    
    %Obtiene las caracteristicas por cada canal
    featureOrig=[];
    for h=1:lenCh
        diffP300=[];
        diffAreaBloques=[];
        diffArea=[];
        diffTortuosidad=[];
        diffCadena=[];
        for j=1:choices
            ERP=ERPgral(range(find(Code(range)==j)),:,:); 
            signal=meanERP(ERP(:,:,bestCH(h)),t,seg,ctipo,mtipo,0,'');

            distP3ERP=distancia(patronF(h).chainSHCC,signal.chainSHCC,dtipo);%Dif entre patronF00 y promERP
            distArea=sum(abs(patronF(h).areaBloques-signal.areaBloques));
            distAreaBloques=patronF(h).areaBloques-signal.areaBloques;

            diffAreaBloques=[diffAreaBloques; distAreaBloques];
            diffArea=[diffArea; distArea];
            diffP300=[diffP300; distP3ERP];
            diffTortuosidad=[diffTortuosidad; signal.tortuosidad];
            diffCadena=[diffCadena; signal.chainSHCC];
        end
        featureOrig=[featureOrig diffAreaBloques diffArea diffP300 diffTortuosidad diffCadena];
    end
    for h=1:lenCh %Toma las mejores caracteristicas de cada canal
        featureClas=featureOrig(:,swF(h).indexFeatures);
        featuresClasPesos=featureClas*swF(h).Variables; %w.x
        [valc,maxcol]=max(featuresClasPesos(1:NumMatrixColumns,:));
        [valr,maxrow]=max(featuresClasPesos(NumMatrixColumns+1:choices,:));
        maxrow=maxrow+NumMatrixColumns;
        lenR=[lenR maxcol];%estos vectores son solo con fines de evaluacion, se pueden
        lenC=[lenC maxrow];%eliminar
    end

    lenF=[lenF; lenC; lenR];
    
    krow=krow+1;
    [a,b]=hist(lenR,unique(lenR));
    [c,d]=max(a);
    l=b(find(a==c));
    lenlr=length(l);
    if lenlr>1
        row(krow)=0;
        krow=krow+1;
        inx_krow=krow;
        for j=1:lenlr
            row(krow)=l(j);
            krow=krow+1;
        end
        row(krow)=0;
    else
        row(krow)=l;
    end

    kcol=kcol+1;
    [a,b]=hist(lenC,unique(lenC));
    [c,d]=max(a);
    l=b(find(a==c));
    lenlc=length(l);
    if lenlc>1
        col(kcol)=0;
        kcol=kcol+1;
        inx_kcol=kcol;
        for j=1:lenlc
            col(kcol)=l(j);
            kcol=kcol+1;
        end
        col(kcol)=0;
    else
        col(kcol)=l;
    end
    
    if lenlr==lenlc
        letras=[letras matrix2letras(row(krow),col(kcol))];
    else
        dif=lenlr-lenlc;
        if dif>0
            letras=[letras '('];
            for j=inx_krow:inx_krow+lenlr-1
                letras=[letras matrix2letras(row(j),col(kcol))];
            end
            letras=[letras ')'];
        else
            letras=[letras '('];
            for j=inx_kcol:inx_kcol+lenlc-1
                letras=[letras matrix2letras(row(krow),col(j))];           
            end
            letras=[letras ')'];
        end
    end
    
end

writeClasification(ruta_clasificacion,sujeto,bestAUC,lenCh,lenF,col,row,letras,coderow,codecol); 