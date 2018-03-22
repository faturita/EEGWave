
%%%Descripcion: The aims of the calibration algorithm are: 
%%%i)   to obtain a set of templates that best represents the subject's P300 
%%%     per electrode, 
%%%ii)  to ascertain the subject's optimum number of stimulation that enables 
%%%     both, an adequate SNR and a decrease of the subject's fatigue caused 
%%%     by excessive stimulation, 
%%%iii) to select the subset of electrodes that provide the best P300 signal 
%      for each subject, and 
%%%iv)  to select the shape features that leads the classifier to get the 
%%%     most accuracy results for each subject.
%%%Ejemplo: calibrationAllCh('/home/mon',16,{'ACS'},180,1)
%%%Parametros de entrada:
%%%sujeto=
%%%   Tipo de dato: cell
%%%   Descripcion: Tres letras mayusculas que identifican los archivos del 
%%%                sujeto a analizar. 
%%%seg=
%%%   Tipo de dato: integer
%%%   Descripcion: Numero de segmentos en los que se divide la curva para 
%%%                discretizarla.
%%%ruta=
%%%   Tipo de dato: string
%%%   Descripcion: Ruta para guardar los archivos con la informacion de las
%%%                cadenas patron por canal, los mejores canales y la epoca 
%%%                optima.
%%%A=
%%%   Tipo de dato: integer
%%%   Descripcion: Numero de P300 necesarios para crear una plantilla.
%%%num_features= Numero de caraceristicas evaluadas para reducir la
%%%   dimensionalidad del vector de caracteristicas.
%%%Salida:
%%%   SUJETOcalibracion.mat: archivo con la informacion de las cadenas  
%%%   plantilla por canal, los mejores canales, la epoca optima, las mejores 
%%%   caraceristicas obtenidas con las mejores plantillas por canal, su 
%%%   indice y pesos.

function calibrationAllCh(ruta,seg,sujeto,A,num_features)

dtipo=1; %%%1=L1;2=Frechet;3=LCS
mtipo=1; %%%1=P2P;2=Woody;3=DTW
ctipo=1; %%%0=SCC;1=SHCC;2=Freeman45;3=90grados
K=15;    %%%Numero de epocas con las que se obtuvo la informacion de la BD


[dataCalor,dataCarino,dataSushi,etiqCalor,etiqCarino,etiqSushi,t]=abreArchivosCalib(ruta);
ERPgral=[dataCalor;dataCarino;dataSushi];
etiqGral=[etiqCalor; etiqCarino; etiqSushi];
etiqIndex=[etiqGral [1:length(etiqGral)]']; %%%indice de ERP

%%%filtra solo P300
etiqP300=etiqIndex(find(etiqIndex(:,2)==1),[1,4],:,:); 
P=length(etiqP300);
etiqP300=[etiqP300 [1:P]'];

%%%filtra solo no P300
etiqNoP300=etiqIndex(find(etiqIndex(:,2)==-1),[1,4],:,:);
N=length(etiqNoP300);
etiqNoP300=[etiqNoP300 [1:N]'];

%Electrodos seleccionados de acuerdo a la teoria y a versiones anteriores
%del algoritmo de calibracion.
       %1 2 3 4 5 6 7 
bestCH=[1 2 3 6 8 9 10];
C=length(bestCH); 

errMean=zeros(1,10);
errStd=zeros(1,10);

tiempo = cputime;
U=floor((P-A)/K);
l=[ones(1,U)';zeros(1,U)'];
k=K;
b=1;
while b
    O=floor(P/k);
    Z=zeros(O,10);
    for o=1:O %%%patron00
        distP3ERP=[];
        V=[];
        for c=1:C %por cada canal
            diffP300=[];
            diffAreaBloques=[];
            diffArea=[];
            diffTortuosidad=[];
            diffCadena=[];
            
            %%%Elige aleatoriamente las p300 a promediar
            etiqP300(:,1)=0;
            etiqNoP300(:,1)=0;
            rndP300=randperm(P);
            etiqP300(rndP300(1:A),1)=1;
            
            ERPp300=ERPgral(etiqP300(rndP300(1:A),2),:,:);
            signal=meanERP(ERPp300(:,:,bestCH(c)),t,seg,ctipo,mtipo,0,['p300/' sujeto '/templateP300/']); %Obtiene el codigo cadena del patron p300
            signal.etiquetas=find(etiqP300(:,1)==1);
            signal.CH=bestCH(c);
            patron(o,c)=signal;
            
            for u=1:U %%%Compara patron00 vs P300 restantes
                %%%Elige aleatoriamente las n p300 no usadas
                indP300=etiqP300(find(etiqP300(:,1)==0),2:3);
                lenIndP300=length(indP300);
                indP300(:,3)= [1:lenIndP300]';
                rnd=randperm(lenIndP300);
                etiqP300(indP300(rnd(1:k),2),1)=1;
                ERP=ERPgral(indP300(rnd(1:k),1),:,:); 
                signal=meanERP(ERP(:,:,bestCH(c)),t,seg,ctipo,mtipo,0,'');
                
                distP3ERP=distancia(patron(o,c).chainSHCC,signal.chainSHCC,dtipo);%Dif entre patron00 y promERP
                distArea=sum(abs(patron(o,c).areaBloques-signal.areaBloques));
                distAreaBloques=patron(o,c).areaBloques-signal.areaBloques;

                diffP300=[diffP300; distP3ERP];
                diffAreaBloques=[diffAreaBloques; distAreaBloques];
                diffArea=[diffArea; distArea];
                diffTortuosidad=[diffTortuosidad; signal.tortuosidad];
                diffCadena=[diffCadena; signal.chainSHCC];
            end
            for u=1:U %%%Compara patron00 vs NoP300
                indNP300=etiqNoP300(find(etiqNoP300(:,1)==0),2:3);
                lenIndNP300=length(indNP300);
                indNP300(:,3)=[1:lenIndNP300]';
                rndNoP300=randperm(lenIndNP300);
                etiqNoP300(indNP300(rndNoP300(1:k),2),1)=1;
                ERP=ERPgral(indNP300(rndNoP300(1:k),1),:,:);
                signal=meanERP(ERP(:,:,bestCH(c)),t,seg,ctipo,mtipo,0,'');
                
                distNP3ERP=distancia(patron(o,c).chainSHCC,signal.chainSHCC,dtipo);%Dif entre patron00 y promERP
                distArea=sum(abs(patron(o,c).areaBloques-signal.areaBloques));
                distAreaBloques=patron(o,c).areaBloques-signal.areaBloques;

                diffP300=[diffP300; distNP3ERP];
                diffAreaBloques=[diffAreaBloques; distAreaBloques];
                diffArea=[diffArea; distArea];
                diffTortuosidad=[diffTortuosidad; signal.tortuosidad];
                diffCadena=[diffCadena; signal.chainSHCC];               
            end
            %%%Analisis de desempenio de la deteccion del P300
            z=AUC([diffP300 l]);
            Z(o,bestCH(c))=z; 
            
            V=[V diffAreaBloques diffArea diffP300 diffTortuosidad diffCadena];
        end
        sw(o)=seleccionCaracteristicas(V,l,num_features)
    end
    bestT=1;
    

    meanAUC=mean(Z)
    stdAUC=std(Z)
    %Encuentra los mejores electrodos y la epoca optima
    ch=find(meanAUC>=0.8);
    if (isempty(ch) & k<K) || k<1
        b=0;
    else
        if ~isempty(ch)
            bestCH=ch;
            bestT=K;
            k=k-1;
        end
        if isempty(ch) & k==K
            i=max(meanAUC);
            ch=find((meanAUC>=i)&(meanAUC>=0.6));
            bestCH=ch;
            bestT=15;
            b=0;
        end
         errMean(epocas,:)=meanAUC;
         errStd(epocas,:)=std(AUCT);
        %Encuentra la plantilla optima por canal
        [bestAUC,bestP]=max(Z);
        bestP=bestP(bestCH);
        for c=1:C
            patronF(c)=patron(bestP(c),c);
        
            %Seleccion de las caracteristicas que tengan el patron con el canal 
            %de mayor AUC
            swF(c).Variables=sw(bestP(c)).Variables;
            swF(c).indexFeatures=sw(bestP(c)).indexFeatures;
        end
    end
end
e1 = cputime-tiempo
dirF=strcat('experimentos_',num2str(num_features),'features/calibracion/',sujeto,'/');
mkdir(dirF);
bestAUC=bestAUC(bestCH);
save(strcat(dirF,'calibracion.mat'),'bestT','bestCH','patronF','seg','swF','num_features','bestAUC');
