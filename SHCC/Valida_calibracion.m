function Valida_calibracion(ruta,sujeto,seg)

epocas=15; %%%numero maximo de epocas 
dtipo=1; %%%1=L1;2=Frechet;3=LCS
mtipo=1; %%%1=P2P;2=Woody;3=DTW
ctipo=0; %%%0=SCC;1=SHCC;2=Freeman45;3=90grados
T=15;    %%%Numero de epocas con las que se obtuvo la informacion de la BD


[dataCalor,dataCarino,dataSushi,etiqCalor,etiqCarino,etiqSushi,t]=abreArchivosCalib(sujeto);
ERPgral=[dataCalor;dataCarino;dataSushi];
etiqGral=[etiqCalor; etiqCarino; etiqSushi];
etiqIndex=[etiqGral [1:length(etiqGral)]']; %%%indice de ERP

%%%filtra solo P300
etiqP300=etiqIndex(find(etiqIndex(:,2)==1),[1,4],:,:); 
lenP300=length(etiqP300);
etiqP300=[etiqP300 [1:lenP300]'];

%%%filtra solo no P300
etiqNoP300=etiqIndex(find(etiqIndex(:,2)==-1),[1,4],:,:);
lenNoP300=length(etiqNoP300);
etiqNoP300=[etiqNoP300 [1:lenNoP300]'];


%Electrodos seleccionados de acuerdo a la teoria y a versiones anteriores
%al algoritmo de calibracion.
       %1 2 3 4 5 6 7 
bestCH=[1 2 3 6 8 9 10];
lenCH=length(bestCH); 

%Las caracteristicas correspondientes a la plantilla con la mayor precision
%por cada canal. Las caracteristicas ya incluyen todos los canales, solo se
%trata de evaluar con cuales caracteristicas se logra la mayor precision.
for j=1:lenCH
    featureClas=swF(j).featureClas;
    Variables=swF(j).Variables;
    featuresClasPesos=featureClas*Variables;%w.x
    
    ldaT=[];
    species=[];

    %Validacion leave-one-out
    for i=1:sampleSize
        LOO_featrues=featuresClasPesos;
        LOO_etiquetas=etiquetasOrig;

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

        svmStruct = svmtrain(LOO_featrues,LOO_etiquetas,'ShowPlot',false);
        svmStructT(i)=svmStruct;
        species = [species; svmclassify(svmStruct,featureTest,'ShowPlot',false)];
    end
    
    %matriz de confusion LDA
    a=length(find(ldaT(sampleSize/2+1:end)==etiquetasOrig(sampleSize/2+1:end)));
    c=length(find(ldaT(sampleSize/2+1:end)~=etiquetasOrig(sampleSize/2+1:end)));
    b=length(find(ldaT(1:sampleSize/2)~=etiquetasOrig(1:sampleSize/2)));
    d=length(find(ldaT(1:sampleSize/2)==etiquetasOrig(1:sampleSize/2)));
    TP_LDA(j)=d/(c+d);
    FP_LDA(j)=b/(a+b);
    TN_LDA(j)=a/(a+b);
    FN_LDA(j)=c/(c+d);
    if isnan(TP_LDA(j))
        TP_LDA(j)=0;
    end
    if isnan(FP_LDA(j))
        FP_LDA(j)=0;
    end
    if isnan(TN_LDA(j))
        TN_LDA(j)=0;  
    end
    if isnan(FN_LDA(j))
        FN_LDA(j)=0;     
    end
    accuracyLDA(j)=(a+d)/(a+b+c+d);     

    %matriz de confusion SVM
    a=length(find(species(sampleSize/2+1:end)==etiquetasOrig(sampleSize/2+1:end)));
    c=length(find(species(sampleSize/2+1:end)~=etiquetasOrig(sampleSize/2+1:end)));
    b=length(find(species(1:sampleSize/2)~=etiquetasOrig(1:sampleSize/2)));
    d=length(find(species(1:sampleSize/2)==etiquetasOrig(1:sampleSize/2)));
    TP_SVM(j)=d/(c+d);
    FP_SVM(j)=b/(a+b);
    TN_SVM(j)=a/(a+b);
    FN_SVM(j)=c/(c+d);
    if isnan(TP_SVM(j))
        TP_SVM(j)=0;
    end
    if isnan(FP_SVM(j))
        FP_SVM(j)=0;
    end
    if isnan(TN_SVM(j))
        TN_SVM(j)=0;  
    end
    if isnan(FN_SVM(j))
        FN_SVM(j)=0;     
    end
    accuracySVM(j)=(a+d)/(a+b+c+d); 
    
    %seleccion aleatoria de una SVM
    rndSVM=randperm(sampleSize);
    svm(j)=svmStructT(rndSVM(1));
end
save(strcat(ruta,sujeto,'/SVM'),'svm');

writeMatrizConfusion(strcat(ruta,sujeto,'/MatrizConfusion.txt'),bestAUC,TP_LDA,FP_LDA,TN_LDA,FN_LDA,accuracyLDA,TP_SVM,FP_SVM,TN_SVM,FN_SVM,accuracySVM);
  