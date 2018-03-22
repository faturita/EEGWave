function writeAUC(datosF,seg)
    arch=strcat(seg,'AUC.txt');
    arch=horzcat(arch);    
    fid = fopen(arch,'w');
    len=length(datosF);
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,7),'\n'), datosF(i,:));
    end
    fclose(fid);