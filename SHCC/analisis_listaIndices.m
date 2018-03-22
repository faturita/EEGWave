clc
clear all
addpath(genpath('/Users/mona/Desktop/doctorado/datosUAMI/p300_database_mat/'));
ruta='./'
seg=16;
np300=180; %%%numero de P300 a promediar para obtener el patron


%         1     2     3      4    5     6      7     8     9     10
sujeto={'ACS';'APM';'ASG';'ASR';'CLL';'DCM'; 'DLP';'DMA';'ELC';'FSZ'; ...
    'GCE';'ICE'; 'JCR';'JLD';'JLP';'JMR';'JSC';'JST'; 'LAC';'LAG';'LGP';'LPS'};
%     11    12     13   14    15    16    17    18     19     20     21   22
%

lenCH=7;

lenSujeto=length(sujeto);
indexF=[];
accuracyF=[];
for n=1:lenSujeto %sujetos
    sujeton=sujeto{n}
    for i=1:238
        load(strcat('/Users/mona/Documents/MATLAB/codigoProyectov11/experimentos_', num2str(i),'features/calibracion/',sujeton,'/calibracion.mat'));
%         for j=1:lenCH
%             %indexF(i,j,1:length(swF(j).indexFeatures))=swF(j).indexFeatures;
%             a=zeros(1,38);
%             a(1:length(swF(j).indexFeatures))=swF(j).indexFeatures;
%             indexF=[indexF; a]
%         end
        fid = fopen(strcat('/Users/mona/Documents/MATLAB/codigoProyectov11/experimentos_', num2str(i),'features/validacion/',sujeton,'_MatrizConfusion.txt'));
        fscanf(fid, strcat(repmat('%f ',1,lenCH)),lenCH);
        accuracyF=[accuracyF; fscanf(fid, strcat(repmat('%f ',1,lenCH)),lenCH)'];
        fclose(fid);
    end

end
% for i=5
%     for j=1:238
%         if isempty(indexF(find(indexF==j)))==0
%             cuenta(j)=length(indexF(find(indexF(i,:)==j)));
%             %cuentaGlobal(j)=length(indexF(find(indexF==j)));
%         end
%     end
% end


%ICE 0.95 todos los electrodos