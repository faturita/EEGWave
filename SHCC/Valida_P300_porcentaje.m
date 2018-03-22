function [accuracy] = Valida_P300_porcentaje(ruta_calibracion,ruta_clasificacion,sujeto,seg)

dtipo=1; %%%1=L1;2=Frechet;3=LCS
mtipo=1; %%%1=P2P;2=Woody;3=DTW
ctipo=1; %%%0=SCC;1=SHCC;2=Freeman45;3=90grados

%[bestT,bestCH,bestAUC,patronF,swF]=readCalibration(strcat(ruta_calibracion,sujeto,'calib.txt'),seg)
load(strcat(ruta_calibracion,sujeto,'/calibracion.mat'));
load(strcat(ruta_calibracion,sujeto,'/SVM.mat'));
[ERPgral,etiqGral,t]=abreArchivosValida(sujeto); 
etiqIndex=[etiqGral [1:length(etiqGral)]']; %indice de ERP

%filtra solo P300
etiqP300=etiqIndex(find(etiqIndex(:,2)==1),[1,4],:,:); 
lenP300=length(etiqP300);
etiqP300=[etiqP300 [1:lenP300]'];

%filtra solo no P300
etiqNoP300=etiqIndex(find(etiqIndex(:,2)==-1),[1,4],:,:);
lenNoP300=length(etiqNoP300);
etiqNoP300=[etiqNoP300 [1:lenNoP300]'];

lenCh=length(bestCH);
featureOrig=[];
%sampleSize=10;
etiquetasOrig=[ones(1,10)';zeros(1,50)'];
    
for h=1:lenCh
    diffP300=[];
    diffAreaBloques=[];
    diffArea=[];
    diffTortuosidad=[];
    diffCadena=[];
    
    etiqP300(:,1)=0;
    etiqNoP300(:,1)=0;
    for i=1:10 %%%Compara patronF00 vs P300
        %%%Prom de n epocas de ERP con p300
        indP300=etiqP300(find(etiqP300(:,1)==0),2:3);
        lenIndP300=length(indP300);
        indP300(:,3)= [1:lenIndP300]';
        rnd=randperm(lenIndP300);
        etiqP300(indP300(rnd(1:bestT),2),1)=1;
        ERP=ERPgral(indP300(rnd(1:bestT),1),:,:); 
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
    for i=1:50
        %%%Prom de n epocas de ERP sin p300
        indNP300=etiqNoP300(find(etiqNoP300(:,1)==0),2:3);
        lenIndNP300=length(indNP300);
        indNP300(:,3)=[1:lenIndNP300]';
        rndNoP300=randperm(lenIndNP300);
        etiqNoP300(indNP300(rndNoP300(1:bestT),2),1)=1;
        ERP=ERPgral(indNP300(rndNoP300(1:bestT),1),:,:);
        signal=meanERP(ERP(:,:,bestCH(h)),t,seg,ctipo,mtipo,0,'');

        distNP3ERP=distancia(patronF(h).chainSHCC,signal.chainSHCC,dtipo);%Dif entre patronF00 y promERP
        distArea=sum(abs(patronF(h).areaBloques-signal.areaBloques));
        distAreaBloques=patronF(h).areaBloques-signal.areaBloques;

        diffAreaBloques=[diffAreaBloques; distAreaBloques];
        diffArea=[diffArea; distArea];
        diffP300=[diffP300; distNP3ERP];
        diffTortuosidad=[diffTortuosidad; signal.tortuosidad];
        diffCadena=[diffCadena; signal.chainSHCC];
    end
    featureOrig=[featureOrig diffAreaBloques diffArea diffP300 diffTortuosidad diffCadena];

end
porcentaje=[];
for h=1:lenCh %Toma las mejores caracteristicas de cada canal
    featureClas=featureOrig(:,swF(h).indexFeatures);
    featuresClasPesos=featureClas*swF(h).Variables;%w.x
   
    ldaT=[];
    clase1=mean(featuresClasPesos(find(etiquetasOrig==1)));
    clase2=mean(featuresClasPesos(find(etiquetasOrig==0)));
    for i=1:length(featuresClasPesos)
        if abs(clase1-featuresClasPesos(i))<abs(clase2-featuresClasPesos(i))
            ldaT=[ldaT; 1];
        else
            ldaT=[ldaT; 0];
        end
    end
    a=length(find(ldaT==etiquetasOrig))
    porcentaje=[porcentaje (a*100)/60]
end
dirF=strcat(ruta_clasificacion);
mkdir(dirF);

writePorcentaje(strcat(dirF,sujeto,'_Porcentaje.txt'),sort(porcentaje,'descend'));


