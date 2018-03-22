function writeCalibration(sujeto,bestT,bestCH,patron,seg,sw,num_features,bestAUC)
    len=length(patron);
    lenCH=length(bestCH);
    [len_sw1,len_sw2]=size(sw(1).featureClas);
    dirF=strcat('experimentos_',num2str(num_features),'features/');
    mkdir(dirF);
    arch=strcat(strcat(dirF,sujeto),'calib.txt');
    arch=horzcat(arch);    
    fid = fopen(arch,'w');
    
    fwrite(fid, int2str(bestT));
    fprintf(fid, '\n');
    fwrite(fid, int2str(len));
    fprintf(fid, '\n');
    fprintf(fid, strcat(repmat('%i ',1,lenCH),'\n'), bestCH);
    fprintf(fid, '\n');
    fprintf(fid, '\n');
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,seg),'\n'), patron(i).chainSHCC);
    end
    fprintf(fid, '\n');
    fprintf(fid, '\n');
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,len),'\n'), patron(i).tortuosidad);
    end
    fprintf(fid, '\n');
    fprintf(fid, '\n');
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,len),'\n'), patron(i).area);
    end
    fprintf(fid, '\n');
    fprintf(fid, '\n');
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,seg-1),'\n'), patron(i).areaBloques);
    end
    fprintf(fid, '\n');
    fprintf(fid, '\n');
    fwrite(fid, int2str(len_sw1));
    fprintf(fid, '\n');
    fwrite(fid, int2str(len_sw2));    
    for i=1:lenCH
        fprintf(fid, '\n');
        for j=1:len_sw1
            fprintf(fid, strcat(repmat('%1.4f ',1,len_sw2),'\n'), sw(i).featureClas(j,:)');
        end
        fprintf(fid, '\n');
        fprintf(fid, '\n');
        fprintf(fid, strcat(repmat('%2.4f ',1,len_sw2),'\n'), sw(i).Variables);
        fprintf(fid, '\n');
        fprintf(fid, '\n');
        fprintf(fid, strcat(repmat('%i ',1,len_sw2),'\n'), sw(i).indexFeatures);
    end
    fprintf(fid, '\n');
    fprintf(fid, strcat(repmat('%1.4f ',1,lenCH),'\n'), bestAUC);
    fclose(fid);