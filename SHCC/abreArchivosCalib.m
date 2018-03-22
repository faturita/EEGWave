
function [dataCalor,dataCarino,dataSushi,etiqCalor,etiqCarino,etiqSushi,t]=abreArchivosCalib(sujeto)

    %Calor
    [dataCalor,etiqueta,ind,states,t,letras] = obten_P300_BCI2000 ([sujeto 'S001R01.mat'],[1:10],800,1,2);
    etiqCalor=[zeros(size(etiqueta,1),1) etiqueta];

    %Carino
    [dataCarino,etiqueta,ind,states,t,letras] = obten_P300_BCI2000 ([sujeto 'S001R02.mat'],[1:10],800,1,2);
    etiqCarino=[zeros(size(etiqueta,1),1) etiqueta];

     %Sushi
    [dataSushi,etiqueta,ind,states,t,letras] = obten_P300_BCI2000 ([sujeto 'S001R03.mat'],[1:10],800,1,2);
    etiqSushi=[zeros(size(etiqueta,1),1) etiqueta];

%     dataC=[];
%     dataCC=[];
%     dataS=[];
% for i=1:10
%     dataC=[dataC dataCalor(:,:,i)];
%     dataCC=[dataCC dataCarino(:,:,i)];
%     dataS=[dataS dataSushi(:,:,i)];
% end
% data=[dataC;dataCC;dataS];
% label=[etiqCalor(:,2); etiqCarino(:,2); etiqSushi(:,2)];
% data
%    

        
