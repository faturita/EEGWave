
function [dataGral,etiqGral,t]=abreArchivosClasif(sujeto)

    dataGral=[];
    etiqGral=[];
      
    %Palabra1
    [data,etiqueta,ind,states,t,letras] = obten_P300_BCI2000 (strcat(sujeto,'S003R01.mat'),[1:10],800,1,2);
    dataGral= data;
    etiqGral=[etiqGral; zeros(size(etiqueta,1),1) etiqueta];

    %Palabra2
    [data,etiqueta,ind,states,t,letras] = obten_P300_BCI2000 (strcat(sujeto,'S003R02.mat'),[1:10],800,1,2);
    dataGral=[dataGral; data];
    etiqGral=[etiqGral; zeros(size(etiqueta,1),1) etiqueta];

    %Palabra3
    [data,etiqueta,ind,states,t,letras] = obten_P300_BCI2000 (strcat(sujeto,'S003R03.mat'),[1:10],800,1,2);
    dataGral=[dataGral; data];
    etiqGral=[etiqGral; zeros(size(etiqueta,1),1) etiqueta];

   

        