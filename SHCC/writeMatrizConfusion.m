function writeMatrizConfusion(sujeto,bestAUC,TP_LDA,FP_LDA,TN_LDA,FN_LDA,accuracyLDA,TP_SVM,FP_SVM,TN_SVM,FN_SVM,accuracySVM)
    arch=sujeto;
    arch=horzcat(arch);    
    fid = fopen(arch,'w');
    len=length(accuracyLDA);
    fprintf(fid, strcat(repmat('%1.4f ',1,len),'\n'), bestAUC);
    fprintf(fid, '\n');  
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,len),'\n'), accuracyLDA(i));
    end
    fprintf(fid, '\n');
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,len),'\n'), TP_LDA(i));
    end
    fprintf(fid, '\n');
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,len),'\n'), FP_LDA(i));
    end
    fprintf(fid, '\n');
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,len),'\n'), TN_LDA(i));
    end
    fprintf(fid, '\n');
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,len),'\n'), FN_LDA(i));
    end
    fprintf(fid, '\n');
    fprintf(fid, '\n');
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,len),'\n'), accuracySVM(i));
    end
    fprintf(fid, '\n');
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,len),'\n'), TP_SVM(i));
    end
    fprintf(fid, '\n');
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,len),'\n'), FP_SVM(i));
    end
    fprintf(fid, '\n');
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,len),'\n'), TN_SVM(i));
    end
    fprintf(fid, '\n');
    for i=1:len
        fprintf(fid, strcat(repmat('%1.4f ',1,len),'\n'), FN_SVM(i));
    end
    fclose(fid);