% extrae epocas de la base de datos colectados en la UNER UAM, 
% 
% [data,etiqueta,ind,states,t,letras] = obten_P300_BCI2000 (archivo,canales,ventana,filtro,flag_tend)
%
% data = matriz de datos extraidos [epocas, no. de muestras, canales]
% etiqueta = vector que indica si los datos tienen (1) o no (0)
%            P300 [etiqueta indicador de fila columna]
% letras = vector que indica la muestra de inicio y fin de las estimulaciones por caracter
%          el ultimo elemento solo indica donde termina el caracter final
% canales = vector con los canales a extraer
% epocas = vector con las epocas a extraer 
% ventana = longitud en ms a extraer de cada estimulacion
% filtro = contiene los coeficientes de los filtros que se desea utilizar
%          para la se???al. filtro es una estructura que contiene los campos
%          filtro.b y filtro.a, cada uno es un arreglo de celdas. Si filtro
%          no es un celda entonces se usa un filtro pasabanda entre 0.1 y
%          12 Hz
% flag_tend = 1 remueve la tendencia de las ventanas  
%             2 remueve tendencia y normaliza l se???al para que la desviacion 
%               estandar este entre [-1 y 1]
%             0 no hace nada de los anteriores.
%
% ERBV  

function [data,etiqueta,ind,states,t,letras] = obten_P300_BCI2000 (archivos,canales,ventana,filtro,flag_tend)

%n_files=length(archivos);

data_x=[];
etiqueta_x=[];
ind_x=[];
%muestrea los datos a 256 milisegundos
ventana=round(ventana*0.256); 
t=linspace(0,ventana/0.256,ventana+1);

file=1;
%for file=1:n_files
    
    load (archivos)

    uncanal=0;
   
    % extraemos los canales deseados
    if length(canales)==1
      canales=[canales,1];
      uncanal=1;
    end

    signal=double(signal(:,canales));
    [n_muestras,n_canales]=size(signal);

    %identificamos los indices donde ocurren los estimulos hasta donde
    %permite la ventana de muestras, para no tener ventanas incompletas
    %de senal
    states.StimulusCode=double(states.StimulusCode);
    ind=find(states.StimulusCode~=0);
    %n_epocas=find(diff(ind)>200);
    ind=find(diff(states.StimulusCode)>0)+1;
    ind=ind(find(states.StimulusCode(ind)));
    ind=ind(find(ind<=n_muestras-ventana));

    %Se identifican donde comienza la estimulaci???n, encuentra donde comienza
    %la estimulaci???n del siguiente caracter
    states.PhaseInSequence=double(states.PhaseInSequence);
    letras=find(diff(states.PhaseInSequence)>0);
    letras=[letras(1:2:end);letras(end)];
 

    % se filtra la se???al con tantos filtros se desee, los coeficientes de los
    % filtros debe estar en una estructura filtro.b{} y filtro.a{}. Si filtro
    % no es una celda entonces se hace un filtrado entre 0.1 y 12 Hz

%     if iscell(filtro)
%         for i=1:length(filtro.b)
%             b=filtro.b{i};
%             a=filtro.a{i};
%             signal=filtfilt(b,a,signal);
%         end
%     else
%Filtro entre 0.1 y 12 hz
        [b,a]=butter(4, [1/1280 3/32]); %Original 1280
        signal=filtfilt(b,a,signal);
%     end

    % flag_tend igual a 2 remueve medias y normaliza la varianza entre 1 y -1 
    
     if flag_tend==2
        %signal=normalizasd(signal);
        [M,N]=size(signal);
        media=ones(M,1)*mean(signal,1);
        signal=signal-media;
    end

    data=zeros(length(ind),ventana+1,n_canales);
    etiqueta=-ones(length(ind),2);

    %extraemos los datos despues de registrarse algun estimulo y
    %etiquetamos a fin de determinar la aparicion del P300
    for i=1:length(ind)
      rowcol=states.StimulusCode(ind(i));
      data(i,:,:)=signal(ind(i):ind(i)+ventana,:);
      if (states.StimulusType(ind(i))==1)
        etiqueta(i,:)=[1,rowcol];
      else
        etiqueta(i,:)=[-1,rowcol];
      end  
    end

    % con flag_tend ~=0 se remueve la tendencia por cada una de las ???pocas.
    if flag_tend~=0
      [n_signal,n_muestras,n_canales]=size(data);
      for i=1:n_signal
        for canal=1:n_canales
          data(i,:,canal)=detrend(data(i,:,canal));
        end
      end  
    end
    
 data_x=cat(1,data_x,data);
 etiqueta_x=cat(1,etiqueta_x,etiqueta);
 ind_x=cat(1,ind_x,ind);
 states_x(file)=states;
%end

data=data_x;
etiqueta=etiqueta_x;
ind=ind_x;
states=states_x;
