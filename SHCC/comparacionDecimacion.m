function [accuracy] = comparacionDecimacion(sujeto,ruta_clasificacion)

[dataCalor,dataCarino,dataSushi,etiqCalor,etiqCarino,etiqSushi,t]=abreArchivosCalib(sujeto);
%Responses=[dataCalor;dataCarino;dataSushi];
%etiqGral=[etiqCalor; etiqCarino; etiqSushi];
Responses=[dataCalor];
etiqGral=[etiqCalor];

etiqIndex=[etiqGral [1:length(etiqGral)]'];
 
[ResponsesV,etiqGralV,t]=abreArchivosValida(sujeto);
etiqIndexV=[etiqGralV [1:length(etiqGralV)]'];

%Del programa SWLDA--------------------------------------------------------
num_features=60
SamplingRate=256
DFfreq=20
DecFact=ceil(SamplingRate./(DFfreq+.000001));
MAfilter=DecFact;

fprintf(1, 'Averaging and Decimating...\n');
first=ceil(((MAfilter-1)/DecFact)+1);
[numresponse,windowlen,numchannels]=size(Responses);
sizex=(length(1:DecFact:windowlen)-first+1)*numchannels;
tresponse=zeros(numresponse,sizex);
for hh=1:numresponse
    %dresponse=filter(ones(1,MAfilter)/MAfilter,1,Responses(hh,:,:))
    dresponse=Responses(hh,1:DecFact:windowlen,:);
    tresponse(hh,:)=reshape(dresponse(1,first:size(dresponse,2),:),1,sizex);
end
%--------------------------------------------------------------------------

%%%filtra solo P300
%CALIBRACION
etiqP300=etiqIndex(find(etiqIndex(:,2)==1),[1,4],:,:); 
lenP300=length(etiqP300);
etiqP300=[etiqP300 [1:lenP300]'];
%VALIDACION
etiqP300V=etiqIndexV(find(etiqIndexV(:,2)==1),[1,4],:,:); 
lenP300V=length(etiqP300V);
etiqP300V=[etiqP300V [1:lenP300V]'];

%%%filtra solo no P300
%CALIBRACION
etiqNoP300=etiqIndex(find(etiqIndex(:,2)==-1),[1,4],:,:);
lenNoP300=length(etiqNoP300);
etiqNoP300=[etiqNoP300 [1:lenNoP300]'];
%VALIDACION
etiqNoP300V=etiqIndexV(find(etiqIndexV(:,2)==-1),[1,4],:,:);
lenNoP300V=length(etiqNoP300V);
etiqNoP300V=[etiqNoP300V [1:lenNoP300V]'];


labels=[ones(lenP300,1); zeros(lenNoP300,1)];
index=[etiqP300(:,2);etiqNoP300(:,2)];

%Del programa SWLDA--------------------------------------------------------
[B,SE,PVAL,in] = stepwisefit(tresponse(index,:),labels,'maxiter',num_features,'display','off','penter',.1,'premove',.15);   
indexFeatures=find(in~=0)
Variables=B(indexFeatures)
Variables=10*Variables/max(abs(Variables));
chin=reshape(in,length(in)/numchannels,numchannels);
[samp,ch]=find(chin==1);
chused=unique(ch);
newind=(samp+first-2)*DecFact;
numchannels=length(chused);
for rr=1:numchannels
    idx=find(ch==chused(rr));
    ch(idx)=rr*ones(1,length(idx));
end

MUD=[];
hh=1;
for gg=1:size(Variables,1)
    MUD(hh:hh+MAfilter-1,1)=ch(gg)*ones(1,MAfilter); %canales
    MUD(hh:hh+MAfilter-1,2)=newind(gg)-MAfilter+1:newind(gg);
    MUD(hh:hh+MAfilter-1,3)=Variables(gg)*ones(1,MAfilter);
    hh=hh+MAfilter;
end
%--------------------------------------------------------------------------
%Del programa P3Classify---------------------------------------------------
Responses=Responses(:,:,chused');
MUD(:,2)=(MUD(:,1)-1)*windowlen;
[numresponse,windowlen,numchannels]=size(Responses);
response1=reshape(Responses,numresponse,numchannels*windowlen);
pscore=response1(:,MUD(:,2)+1)*MUD(:,3);
%--------------------------------------------------------------------------

%Objetivo:Seleccionar aleatoriamente 20 muestras de 15 epocas c/u tanto
%para P300 como para nonP300
sampleSize=10
bestT=15
cflash=zeros(sampleSize,bestT);
for i=1:sampleSize %Seleccionar aleatoriamente
    %%%Prom de n epocas de ERP con p300
    indP300=etiqP300(find(etiqP300(:,1)==0),2:3);
    lenIndP300=length(indP300);
    indP300(:,3)= [1:lenIndP300]';
    rnd=randperm(lenIndP300);
    etiqP300(indP300(rnd(1:bestT),2),1)=1;
    cflash(i,:)=pscore(indP300(rnd(1:bestT),1)); 
    cflash(i,:)=cumsum(cflash(i,:));
end
score=cflash(:,bestT);
for i=1:sampleSize
    %%%Prom de n epocas de ERP sin p300
    indNP300=etiqNoP300(find(etiqNoP300(:,1)==0),2:3);
    lenIndNP300=length(indNP300);
    indNP300(:,3)=[1:lenIndNP300]';
    rndNoP300=randperm(lenIndNP300);
    etiqNoP300(indNP300(rndNoP300(1:bestT),2),1)=1;
    cflash(i,:)=pscore(indNP300(rndNoP300(1:bestT),1));
    cflash(i,:)=cumsum(cflash(i,:));
end
score=[score; cflash(:,bestT)]


ldaT=[];
species=[];
labels=[ones(sampleSize,1); zeros(sampleSize,1)];
%Validacion leave-one-out
for i=1:20
    LOO_featrues=score;
    LOO_etiquetas=labels;

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
a=length(find(ldaT(sampleSize+1:end)==labels(sampleSize+1:end)));
c=length(find(ldaT(sampleSize+1:end)~=labels(sampleSize+1:end)));
b=length(find(ldaT(1:sampleSize)~=labels(1:sampleSize)));
d=length(find(ldaT(1:sampleSize)==labels(1:sampleSize)));
TP_LDA=d/(c+d);
FP_LDA=b/(a+b);
TN_LDA=a/(a+b);
FN_LDA=c/(c+d);
if isnan(TP_LDA)
    TP_LDA=0;
end
if isnan(FP_LDA)
    FP_LDA=0;
end
if isnan(TN_LDA)
    TN_LDA=0;  
end
if isnan(FN_LDA)
    FN_LDA=0;     
end
accuracyLDA=(a+d)/(a+b+c+d);    

%matriz de confusion SVM
a=length(find(species(sampleSize+1:end)==labels(sampleSize+1:end)));
c=length(find(species(sampleSize+1:end)~=labels(sampleSize+1:end)));
b=length(find(species(1:sampleSize)~=labels(1:sampleSize)));
d=length(find(species(1:sampleSize)==labels(1:sampleSize)));
TP_SVM=d/(c+d);
FP_SVM=b/(a+b);
TN_SVM=a/(a+b);
FN_SVM=c/(c+d);
if isnan(TP_SVM)
    TP_SVM=0;
end
if isnan(FP_SVM)
    FP_SVM=0;
end
if isnan(TN_SVM)
    TN_SVM=0;  
end
if isnan(FN_SVM)
    FN_SVM=0;     
end
accuracySVM=(a+d)/(a+b+c+d);

dirF=strcat(ruta_clasificacion);
mkdir(dirF);
writeMatrizConfusion(strcat(dirF,sujeto,'_MatrizConfusion.txt'),[],TP_LDA,FP_LDA,TN_LDA,FN_LDA,accuracyLDA,TP_SVM,FP_SVM,TN_SVM,FN_SVM,accuracySVM);




