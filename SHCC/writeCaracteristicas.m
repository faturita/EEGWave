function writeCaracteristicas(arch,datosF)
    fid = fopen(arch,'w');
    len=length(datosF);
    for i=1:len
        fprintf(fid, strcat(repmat('%i ',1,2),'\n'), datosF(i,:));
    end
    fclose(fid);