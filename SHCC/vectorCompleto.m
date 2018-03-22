%%%Descripci??n: Algoritmo de calibracion. El algoritmo obtiene un n??mero
%%%             ??ptimo de ??pocas, los canales con la mejor tasa de clasifi-
%%%             caci??n y una cadena ??nica que representa un patr??n de la 
%%%             onda P300 por sujeto.
%%%Ejemplo: calibracion({'ACS'},40,'/home/mon')
%%%Par??metros de entrada:
%%%sujeto=
%%%   Tipo de dato: cell
%%%   Descripci??n: Tres letras mayusculas que identifican los archivos del 
%%%                sujeto a analizar. 
%%%seg=
%%%   Tipo de dato: integer
%%%   Descripci??n: N??mero de segmentos en los que se divide la curva para 
%%%                discretizarla.
%%%ruta=
%%%   Tipo de dato: string
%%%   Descripci??n: Ruta para guardar los archivos con la informaci??n de las
%%%                cadenas patr??n por canal, los mejores canales y la ??poca 
%%%                ??ptima.
%%%Salida:
%%%   SUJETOcalib.txt: archivo con la informaci??n de las cadenas patr??n por  
%%%   canal, los mejores canales y la ??poca ??ptima.   

function vectorCompleto(sujeto,seg,ruta)

np300=180; %%%n??mero de P300 a promediar para obtener el patr??n
epocas=15; %%%n??mero m??ximo de ??pocas 
dtipo=1 %%%1=L1;2=Frechet;3=LCS
mtipo=1 %%%1=P2P;2=Woody;3=DTW
ctipo=1 %%%0=SCC;1=SHCC;2=Freeman45??;3=Freeman35??;4=Freeman25??;5=Freeman15??;6=binaria

%[ERPgral,etiqGral,t]=abreArchivosValida(sujeto); 
[ERPgral,etiqGral,t]=abreArchivosCalib(sujeto); 
etiqIndex=[etiqGral [1:length(etiqGral)]']; %%%indice de ERP

%%%filtra solo P300
etiqP300=etiqIndex(find(etiqIndex(:,2)==1),[1,4],:,:); 
lenP300=length(etiqP300);
etiqP300=[etiqP300 [1:lenP300]'];

%%%filtra solo no P300
etiqNoP300=etiqIndex(find(etiqIndex(:,2)==-1),[1,4],:,:);
lenNoP300=length(etiqNoP300);
etiqNoP300=[etiqNoP300 [1:lenNoP300]'];

tiempo = cputime;
bestCH=[1 2 3 6 8 9 10];
lenCh=length(bestCH);

expMeanP300=floor(lenP300/epocas);
expP300=floor((lenP300-np300)/epocas);
expNoP300=floor(lenNoP300/epocas); 

%AUCcontorno=zeros(expMeanP300,length(t),lenCh);
AUCcontorno=[];
promAUCcontorno=[];
stdAUCcontorno=[];


for h=1:lenCh %por cada canal
    h
    for j=1:expMeanP300 %%%patronP300
    j
        ERPP300=[];
        for i=1:expP300 %%%Compara patronP300 vs P300 restantes
            %%%Elige aleatoriamente las n p300 no usadas
            %rand('seed',i);
            rnd=randperm(lenP300);
            ERP=ERPgral(etiqP300(rnd(1:epocas),2),:,:); 
            ERPprom=mean(ERP(:,:,bestCH(h)),1);
            ERPP300=[ERPP300; ERPprom 1];
        end
        for i=1:expNoP300 %%%Compara patronP300 vs NoP300
            %%%Prom de n epocas de ERP con p300
            %rand('seed',i+10)   
            rndNoP300=randperm(lenNoP300);
            ERP=ERPgral(etiqNoP300(rndNoP300(1:epocas),2),:,:);
            ERPprom=mean(ERP(:,:,bestCH(h)),1);
            ERPP300=[ERPP300; ERPprom 0];
        end
        %%%An??lisis de desempe??o de la detecci??n de la P300
        %AUCcontorno(j,:,h)=AUC(ERPP300);     
        AUCcontorno=[AUCcontorno; AUC(ERPP300)];     
    end
    promAUCcontorno=[promAUCcontorno; mean(AUCcontorno)]
    stdAUCcontorno=[stdAUCcontorno; std(AUCcontorno)]
end
e1 = cputime-tiempo


 datos=0
   %letras=detectaP300(sujeto,bestT,bestP,bestCH,length(bestCH),seg)


%writeCalibration(sujeto,bestT,bestCH,bestP,seg);
%writeCalibrationExp(strcat(sujeto,'_AUC.txt'),errMean);
%writeCalibrationExp(strcat(sujeto,'_AUCstd.txt'),errStd);
%Valida(ruta,sujeto,bestP,seg,bestT);
%writeValidacion(strcat(ruta,sujeto,'validacion'),validacion
%);