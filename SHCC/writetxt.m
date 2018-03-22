function writetxt(name,tiempo,amplitud,tiempoSeg,amplitudSeg,tortuosidad,difpend,chain1,chain2,chain3,chain4,chain5,chain6,countNeg1,countPos1,countNeg2,countPos2,indMaxVolt,MaxVolt)
    fid = fopen(name,'w');
    lenT=length(tiempo);
    for i=1:lenT
        fprintf(fid, strcat(repmat('%1.4f ',1,lenT),'\n'), tiempo(i));
    end
    fprintf(fid, '\n');
    for i=1:lenT
        fprintf(fid, strcat(repmat('%1.4f ',1,lenT),'\n'), amplitud(i));
    end
    fprintf(fid, '\n');
    lenx=length(tiempoSeg);
    for i=1:lenx
        fprintf(fid, strcat(repmat('%1.4f ',1,lenx),'\n'), tiempoSeg(i));
    end
    fprintf(fid, '\n');
    for i=1:lenx
        fprintf(fid, strcat(repmat('%1.4f ',1,lenx),'\n'), amplitudSeg(i));
    end
    fprintf(fid, '\n');
    fprintf(fid, strcat(repmat('%1.4f ',1,1),'\n'), tortuosidad);
    fprintf(fid, strcat(repmat('%1.10f ',1,1),'\n'), difpend);

    fwrite(fid, int2str(indMaxVolt));
    fprintf(fid, '\n');
    fprintf(fid, strcat(repmat('%1.4f ',1,1),'\n'), MaxVolt);
    fwrite(fid, int2str(countPos1));
    fprintf(fid, '\n');
    fwrite(fid, int2str(countNeg1));
    fprintf(fid, '\n');
    fwrite(fid, int2str(countPos2));
    fprintf(fid, '\n');
    fwrite(fid, int2str(countNeg2));
    fprintf(fid, '\n');
    
    for i=1:lenx-1
        fprintf(fid, strcat(repmat('%1.4f ',1,lenx-1),'\n'), chain1(i));
    end
    fprintf(fid, '\n');
    for i=1:lenx-1
        fprintf(fid, strcat(repmat('%1.4f ',1,lenx-1),'\n'), chain2(i));
    end
    fprintf(fid, '\n');
    for i=1:lenx-1
        fprintf(fid, strcat(repmat('%1.4f ',1,lenx-1),'\n'), chain3(i));
    end
    fprintf(fid, '\n');
    for i=1:lenx-1
        fprintf(fid, strcat(repmat('%1.4f ',1,lenx-1),'\n'), chain4(i));
    end
    fprintf(fid, '\n');
    for i=1:lenx-1
        fprintf(fid, strcat(repmat('%1.4f ',1,lenx-1),'\n'), chain5(i));
    end
    fprintf(fid, '\n');
    for i=1:lenx-1
        fprintf(fid, strcat(repmat('%1.4f ',1,lenx-1),'\n'), chain6(i));
    end
    fprintf(fid, '\n');
    fprintf(fid, '\n');
    fclose(fid);