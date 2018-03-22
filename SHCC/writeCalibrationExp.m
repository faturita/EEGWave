function writeCalibrationExp(arch,AUCT)
    fid = fopen(arch,'w');
    AUCTtot=AUCT';
    fprintf(fid, strcat(repmat(' %.4f ',1,10),'\n'), AUCTtot);
    fclose(fid);