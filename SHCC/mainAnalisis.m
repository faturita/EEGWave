ruta='./';
%         1     2     3      4    5     6      7     8     9     10   
sujeto={'ACS';'APM';'ASG';'ASR';'CLL';'DCM'; 'DLP';'DMA';'ELC';'FSZ'; ...
    'GCE';'ICE'; 'JCR';'JLD';'JLP';'JMR';'JSC';'JST'; 'LAC';'LAG';'LGP';'LPS'};
%     11    12     13   14    15    16    17    18     19     20     21   22          
lenSujeto=length(sujeto);
% %Graficas de comparacion entre svm y lda 
% lda=zeros(238,lenSujeto,7);
% svm=zeros(238,lenSujeto,7);
% for i=1:238
%     for n=1:lenSujeto %sujetos
%         C = textread(strcat(ruta,'experimentos_',int2str(i),'features/validacion/',sujeto{n},'_MatrizConfusion.txt'), '%s','delimiter', '\n');
%         lda(i,n,:)=str2num(str2mat(C(3)));
%         svm(i,n,:)=str2num(str2mat(C(9)));
%     end
% end

% %promedio de todas las caracteristicas por sujeto
% for n=1:lenSujeto
%     a=[];
%     for j=1:7
%         a=[a; mean(lda(:,n,j)) std(lda(:,n,j))];
%     end
%     a
%     a=sort(a,'descend')
% end

% %promedio de todas las caracteristicas promedios generales
% c=[]
% for n=1:lenSujeto
%     a=[]
%     for j=1:7
%         a=[a mean(svm(:,n,j))];
%     end
%     a=sort(a,'descend')
%     c=[c; a]
% end
% c

% %Grafica de caracteristicas 
%  maxFeatures=zeros(lenSujeto,238,7); 
% for n=1:lenSujeto %sujetos
% %     plot(1:238,maxFeatures(1,:,1));
% %     hold on; title(sujeto{n})
% %     xlabel('Features')
% %     ylabel('Number of Instances')
% %     hold off
%     count=zeros(34,7);
%     for i=1:238
%         i
%         load(strcat(ruta,'experimentos_',int2str(i),'features/calibracion/',sujeto{n},'/','calibracion.mat'))
%         
%         for j=1:7
%             %maxFeatures(n,i,j)=length(swF(j).indexFeatures);
%             for h=1:length(swF(j).indexFeatures)
%                 switch swF(j).indexFeatures(h)
%                     case {1,35,69,103,137,171,205}
%                         count(1,j)=count(1,j)+1;
%                     case {2,36,70,104,138,172,206}
%                         count(2,j)=count(2,j)+1;
%                     case {3,37,71,105,139,173,207}
%                         count(3,j)=count(3,j)+1;
%                     case {4,38,72,106,140,174,208}
%                         count(4,j)=count(4,j)+1;
%                     case {5,39,73,107,141,175,209}
%                         count(5,j)=count(5,j)+1;
%                     case {6,40,74,108,142,176,210}
%                         count(6,j)=count(6,j)+1;
%                     case {7,41,75,109,143,177,211}
%                         count(7,j)=count(7,j)+1;
%                     case {8,42,76,110,144,178,212}
%                         count(8,j)=count(8,j)+1;
%                     case {9,43,77,111,145,179,213}
%                         count(9,j)=count(9,j)+1;
%                     case {10,44,78,112,146,180,214}
%                         count(10,j)=count(10,j)+1;
%                     case {11,45,79,113,147,181,215}
%                         count(11,j)=count(11,j)+1;
%                     case {12,46,80,114,148,182,216}
%                         count(12,j)=count(12,j)+1;
%                     case {13,47,81,115,149,183,217}
%                         count(13,j)=count(13,j)+1;
%                     case {14,48,82,116,150,184,218}
%                         count(14,j)=count(14,j)+1;
%                     case {15,49,83,117,151,185,219}
%                         count(15,j)=count(15,j)+1;
%                     case {16,50,84,118,152,186,220}
%                         count(16,j)=count(16,j)+1;
%                     case {17,51,85,119,153,187,221}
%                         count(17,j)=count(17,j)+1;
%                     case {18,52,86,120,154,188,222}
%                         count(18,j)=count(18,j)+1;
%                     case {19,53,87,121,155,189,223}
%                         count(19,j)=count(19,j)+1;
%                     case {20,54,88,122,156,190,224}
%                         count(20,j)=count(20,j)+1;
%                     case {21,55,89,123,157,191,225}
%                         count(21,j)=count(21,j)+1;
%                     case {22,56,90,124,158,192,226}
%                         count(22,j)=count(22,j)+1;
%                     case {23,57,91,125,159,193,227}
%                         count(23,j)=count(23,j)+1;
%                     case {24,58,92,126,160,194,228}
%                         count(24,j)=count(24,j)+1;
%                     case {25,59,93,127,161,195,229}
%                         count(25,j)=count(25,j)+1;
%                     case {26,60,94,128,162,196,230}
%                         count(26,j)=count(26,j)+1;
%                     case {27,61,95,129,163,197,231}
%                         count(27,j)=count(27,j)+1;
%                     case {28,62,96,130,164,198,232}
%                         count(28,j)=count(28,j)+1;
%                     case {29,63,97,131,165,199,233}
%                         count(29,j)=count(29,j)+1;
%                     case {30,64,98,132,166,200,234}
%                         count(30,j)=count(30,j)+1;
%                     case {31,65,99,133,167,201,235}
%                         count(31,j)=count(31,j)+1;
%                     case {32,66,100,134,168,202,236}
%                         count(32,j)=count(32,j)+1;
%                     case {33,67,101,135,169,203,237}
%                         count(33,j)=count(33,j)+1;
%                     case {34,68,102,136,170,204,238}
%                         count(34,j)=count(34,j)+1; 
%                 end  
%             end
%         end
%     end
%     bar(count);figure(gcf);
%     title(sujeto{n})
%     xlabel('Features')
%     ylabel('Number of Instances')
% end

% %Clasificacion por fila y columna
% colsO=[9  7  12  9  12  9  7  12  9  8  9  7  9  7  8  9];
% rowsO=[1  1   2  3   3  1  1   3  2  3  3  4  4  4  2  2];
% len=length(colsO)
% palabraO='CALORCARINOSUSHI';
% for n=1:lenSujeto %sujetos
%     for i=1:238
%         C = textread(strcat(ruta,'experimentos_',int2str(i),'features/clasificacion_CCS/',sujeto{n},'_clasificacion.txt'), '%s','delimiter', '\n');
%         cols=str2num(str2mat(C(55)));
%         rows=str2num(str2mat(C(56)));
%         ctrl_cols=zeros(1,len);
%         ctrl_rows=zeros(1,len);
%         ctrl_col_rep=zeros(1,len);
%         ctrl_row_rep=zeros(1,len);
%         porcol=zeros(1,len);
%         porrow=zeros(1,len);
%         j_cols=1;
%         j_rows=1;
%         for j=1:length(colsO)
%             %Columnas
%             if colsO(j)==cols(j_cols)
%                 ctrl_cols(j)=ctrl_cols(j)+1;
%             elseif cols(j_cols)==0
%                 h=j_cols+1;
%                 ctrl_rep=1;
%                 while cols(h)~=0
%                     if colsO(j)==cols(h)
%                         ctrl_cols(j)=ctrl_cols(j)+1;
%                     else
%                         ctrl_rep=ctrl_rep+1;
%                     end
%                     h=h+1;                    
%                 end
%                 j_cols=h;
%                 h=h-2;
%                 ctrl_col_rep(j)=ctrl_rep;
%             end
%             j_cols=j_cols+1;
%             if ctrl_cols(j)==1
%                 if ctrl_col_rep(j)==0
%                     porcol(j)=1;
%                 else
%                     porcol(j)=(100/ctrl_col_rep(j))/100;
%                 end
%             end
%             
%             %filas
%             if rowsO(j)==rows(j_rows)
%                 ctrl_rows(j)=ctrl_rows(j)+1;
%             elseif rows(j_rows)==0
%                 h=j_rows+1;
%                 ctrl_rep=1;
%                 while rows(h)~=0
%                     if rowsO(j)==rows(h)
%                         ctrl_rows(j)=ctrl_rows(j)+1;
%                     else
%                         ctrl_rep=ctrl_rep+1;
%                     end
%                     h=h+1;                    
%                 end
%                 j_rows=h;
%                 h=h-2;
%                 ctrl_row_rep(j)=ctrl_rep;
%             end
%             j_rows=j_rows+1;
%             if ctrl_rows(j)==1
%                 if ctrl_row_rep(j)==0
%                     porrow(j)=1;
%                 else
%                     porrow(j)=(100/ctrl_row_rep(j))/100;
%                 end
%             end
%         end
%         pRow(i,n)=(sum(porrow)*100)/len;
%         pCol(i,n)=(sum(porcol)*100)/len
%     end
%             %plot(1:238,pRow(:,n),'x')
%         %figure;plot(1:238,pCol(:,n),'x')
% end
% pRow
% pCol

palabraO='CALORCARINOSUSHI';
for n=5:lenSujeto %sujetos
    for i=225:238
        C = textread(strcat(ruta,'experimentos_',int2str(i),'features/clasificacion_CCS/',sujeto{n},'_clasificacion.txt'), '%s','delimiter', '\n');
        palabra=C(57);
        palabra=palabra{1}
        count=0;
        h_mod=1;
        len=16
        for h=1:len
            palabra(h_mod)
            if strcmp(palabraO(h),palabra(h_mod))==1
                count(h)=1;
            elseif strcmp(palabra(h_mod),'(')==1
                ctrl_rep=1;
                j=h_mod+1;
                palabra(j);
                ctrl_w=0;
                while strcmp(palabra(j),')')==0
                    if strcmp(palabraO(h),palabra(j))==1
                        ctrl_w=1;
                    else
                        ctrl_rep=ctrl_rep+1;
                    end
                    j=j+1;
                end
                h_mod=j;
                if ctrl_w==1
                    count(h)=(100/ctrl_rep)/100;
                else
                    count(h)=0;
                end
            end
            h_mod=h_mod+1;
        end
        words(i,n)=(sum(count)*100)/len;
    end
end
