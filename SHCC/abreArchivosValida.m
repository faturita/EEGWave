
function [dataGral,etiqGral,t]=abreArchivosValida(sujeto)

    dataGral=[];
    etiqGral=[];
      
    %Sushi
    [data,etiqueta,ind,states,t,letras] = obten_P300_BCI2000 (strcat(sujeto,'S002R01.mat'),[1:10],800,1,2);
    dataGral= data;
    etiqGral=[etiqGral; zeros(size(etiqueta,1),1) etiqueta];
