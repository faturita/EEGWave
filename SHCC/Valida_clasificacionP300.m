function [accuracy] = Valida_clasificacionP300(rutaDatos,ruta_calibracion,ruta_clasificacion,sujeto,seg)

dtipo=1; %%%1=L1;2=Frechet;3=LCS
mtipo=1; %%%1=P2P;2=Woody;3=DTW
ctipo=1; %%%0=SCC;1=SHCC;2=Freeman45;3=90grados

%[bestT,bestCH,bestAUC,patronF,swF]=readCalibration(strcat(ruta_calibracion,sujeto,'calib.txt'),seg)
load(strcat(ruta_calibracion,sujeto,'/calibracion.mat'));
load(strcat(ruta_calibracion,sujeto,'/SVM.mat'));
[ERPgral,etiqGral,t]=abreArchivosValida(rutaDatos); 
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
for h=1:lenCh %Toma las mejores caracteristicas de cada canal
    featureClas=featureOrig(:,swF(h).indexFeatures);
    featuresClasPesos=featureClas*swF(h).Variables;%w.x
    
    ldaT=[];
    species=[];
    
    %Validacion leave-one-out
    for i=1:20
  
        LOO_featrues=featuresClasPesos;
        LOO_etiquetas=etiquetasOrig;

        %bestfeatures=max(featuresClasPesos)
        featureTest=LOO_featrues(i,:);
        LOO_featrues(i,:)=[];
        LOO_etiquetas(i,:)=[];

        clase1=mean(LOO_featrues(find(LOO_etiquetas==1)));
        clase2=mean(LOO_featrues(find(LOO_etiquetas==0)));
        if abs(clase1-featureTest) < abs(clase2-featureTest)
            ldaT=[ldaT; 1];
        else
            ldaT=[ldaT; 0];
        end

        species = [species; svmclassify(svm(h),featureTest,'ShowPlot',false)];
    end

    %matriz de confusion LDA
    a=length(find(ldaT(sampleSize+1:end)==etiquetasOrig(sampleSize+1:end)));
    c=length(find(ldaT(sampleSize+1:end)~=etiquetasOrig(sampleSize+1:end)));
    b=length(find(ldaT(1:sampleSize)~=etiquetasOrig(1:sampleSize)));
    d=length(find(ldaT(1:sampleSize)==etiquetasOrig(1:sampleSize)));
    TP_LDA(h)=d/(c+d);
    FP_LDA(h)=b/(a+b);
    TN_LDA(h)=a/(a+b);
    FN_LDA(h)=c/(c+d);
    if isnan(TP_LDA(h))
        TP_LDA(h)=0;
    end
    if isnan(FP_LDA(h))
        FP_LDA(h)=0;
    end
    if isnan(TN_LDA(h))
        TN_LDA(h)=0;  
    end
    if isnan(FN_LDA(h))
        FN_LDA(h)=0;     
    end
    accuracyLDA(h)=(a+d)/(a+b+c+d);    

    %matriz de confusion SVM
    a=length(find(species(sampleSize+1:end)==etiquetasOrig(sampleSize+1:end)));
    c=length(find(species(sampleSize+1:end)~=etiquetasOrig(sampleSize+1:end)));
    b=length(find(species(1:sampleSize)~=etiquetasOrig(1:sampleSize)));
    d=length(find(species(1:sampleSize)==etiquetasOrig(1:sampleSize)));
    TP_SVM(h)=d/(c+d);
    FP_SVM(h)=b/(a+b);
    TN_SVM(h)=a/(a+b);
    FN_SVM(h)=c/(c+d);
    if isnan(TP_SVM(h))
        TP_SVM(h)=0;
    end
    if isnan(FP_SVM(h))
        FP_SVM(h)=0;
    end
    if isnan(TN_SVM(h))
        TN_SVM(h)=0;  
    end
    if isnan(FN_SVM(h))
        FN_SVM(h)=0;     
    end
    accuracySVM(h)=(a+d)/(a+b+c+d);
end
dirF=strcat(ruta_clasificacion);
mkdir(dirF);
writeMatrizConfusion(strcat(dirF,sujeto,'_MatrizConfusion.txt'),bestAUC,TP_LDA,FP_LDA,TN_LDA,FN_LDA,accuracyLDA,TP_SVM,FP_SVM,TN_SVM,FN_SVM,accuracySVM);



