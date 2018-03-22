function writeFeatures(arch,errMean,errStd)
    fid = fopen(arch,'w');
    fprintf(fid, strcat(repmat('%1.4f ',1,2),'\n'), errMean,errStd);
    fclose(fid);