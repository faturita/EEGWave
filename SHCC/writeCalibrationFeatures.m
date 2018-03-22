function writeCalibrationFeatures(arch,errMean)
    fid = fopen(arch,'w');
    for i=1:7
        fprintf(fid, strcat(repmat(' %.4f ',1,39),'\n'), errMean(:,:,i));
    end
    fclose(fid);