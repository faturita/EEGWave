function writeValidacion(sujeto,validacion)
    arch=strcat(sujeto,'.txt')
    fid = fopen(arch,'w');
    meanEspecificidad=validacion.meanEspecificidad';
    fprintf(fid, 'mEspecificidad   ');
    fprintf(fid, strcat(repmat(' %.4f ',1,10),'\n'), meanEspecificidad);
    fprintf(fid, 'sEspecificidad   ');
    stdEspecificidad=validacion.stdEspecificidad';
    fprintf(fid, strcat(repmat(' %.4f ',1,10),'\n'), stdEspecificidad);
    
    meanSensibilidad=validacion.meanSensibilidad';
    fprintf(fid, 'mSensibilidad   ');
    fprintf(fid, strcat(repmat(' %.4f ',1,10),'\n'), meanSensibilidad);
    fprintf(fid, 'sSensibilidad   ');
    stdSensibilidad=validacion.stdSensibilidad';
    fprintf(fid, strcat(repmat(' %.4f ',1,10),'\n'), stdSensibilidad);
    
    meanAccuracy=validacion.meanAccuracy';
    fprintf(fid, 'mAccuracy       ');
    fprintf(fid, strcat(repmat(' %.4f ',1,10),'\n'), meanAccuracy);
    fprintf(fid, 'sAccuracy       ');
    stdAccuracy=validacion.stdAccuracy';
    fprintf(fid, strcat(repmat(' %.4f ',1,10),'\n'), stdAccuracy);
    fclose(fid);
    