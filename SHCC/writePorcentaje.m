function writePorcentaje(sujeto,porcentaje) 
    arch=sujeto;
    arch=horzcat(arch);    
    fid = fopen(arch,'w');
    len=length(porcentaje);
    fprintf(fid, strcat(repmat('%1.4f ',1,len),'\n'), porcentaje);
    fclose(fid);
