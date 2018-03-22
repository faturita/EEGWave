%% P300 detection based on  shape feature vector 
% Programa principal
clc
clear all
rutaDatos='/Users/mona/Documents/doctorado/AdquisicionDatosBCI/datosUAMI/p300_database_mat/'
ruta='/Users/mona/Desktop/articulos/articuloP300/Experimentos/'
addpath(genpath(ruta));
seg=16;
A=180; %%%numero de P300 a promediar para obtener el patron


%         1     2     3      4    5     6      7     8     9     10   
sujeto={'ACS';'APM';'ASG';'ASR';'CLL';'DCM'; 'DLP';'DMA';'ELC';'FSZ'; ...
    'GCE';'ICE'; 'JCR';'JLD';'JLP';'JMR';'JSC';'JST'; 'LAC';'LAG';'LGP';'LPS'};
%     11    12     13   14    15    16    17    18     19     20     21   22          
                            
lenSujeto=length(sujeto);
for i=238:238 %Desde 1 hasta el numero maximo de caracteristicas

    for n=1:22%lenSujeto %Por cada sujeto
        sujeton=sujeto{n}
        calibrationAllCh(strcat(rutaDatos,sujeton,'/',sujeton,'001/',sujeton),seg,sujeton,A,i) %Algoritmo de calibracion
        %Valida_calibracion(strcat(ruta,'experimentos_',int2str(i),'features/calibracion/'),sujeton,seg); %Evalua el algoritmo de calibracion
        Valida_clasificacionP300(strcat(rutaDatos,sujeton,'/',sujeton,'002/',sujeton),strcat(ruta,'experimentos_',int2str(i),'features/calibracion/'),strcat(ruta,'experimentos_',int2str(i),'features/validacion/'),sujeton,seg); %Valida el algoritmo de calibracion
        %Valida_P300_porcentaje(strcat(ruta,'experimentos_',int2str(i),'features/calibracion/'),strcat(ruta,'experimentos_',int2str(i),'features/validacion/'),sujeton,seg); %Valida el algoritmo de calibracion
        letras=detectaSimbolo(strcat(ruta,'experimentos_',int2str(i),'features/calibracion/'),strcat(ruta,'experimentos_',int2str(i),'features/clasificacion_CCS/'),strcat(rutaDatos,sujeton,'/',sujeton,'001/',sujeton),sujeton,seg); %Deteccion de letras
    end
end

