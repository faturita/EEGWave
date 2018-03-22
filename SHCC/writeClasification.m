function writeClasification(ruta_clasificacion,sujeto,bestAUC,lenCH,lenF,col,row,letras,coderow,codecol)
    mkdir(ruta_clasificacion);
    arch=strcat(strcat(ruta_clasificacion,sujeto),'_clasificacion.txt');
    arch=horzcat(arch);    
    fid = fopen(arch,'w');
    fprintf(fid, strcat(repmat('%1.4f ',1,length(bestAUC)),'\n'), bestAUC);
    fprintf(fid, '\n'); 
    fwrite(fid, int2str(codecol));
    fprintf(fid, '\n');
    fwrite(fid, int2str(coderow));
    fprintf(fid, '\n'); 
    fprintf(fid, '\n');
    for i=1:length(lenF)
        fprintf(fid, strcat(repmat('%i ',1,lenCH),'\n'), lenF(i,:));
        if mod(i,2) == 0
            fprintf(fid, '\n');
        end
    end
    
    fprintf(fid, '\n');
    fwrite(fid, int2str(col));
    fprintf(fid, '\n');
    fwrite(fid, int2str(row));
    fprintf(fid, '\n');
    fprintf(fid, strcat(repmat('%s ',1,length(letras)),'\n'), letras);
    
    
    fclose(fid);