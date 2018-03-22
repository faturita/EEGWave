
function [bestT,bestCH,bestAUC,patron,sw]=readCalibration(arch,seg)
bestCH=[];
bestAUC=[];
tortuosidad=[];
area=[];

fid = fopen(arch);
bestT=fscanf(fid, '%i',1);
lenCH=fscanf(fid, '%i',1);

bestCH=[bestCH; fscanf(fid, strcat(repmat('%i ',1,lenCH)),lenCH)'];

for i=1:lenCH
    patron(i).chainSHCC=fscanf(fid, strcat(repmat('%f ',1,seg)),seg)';
end
tortuosidad=[tortuosidad; fscanf(fid, strcat(repmat('%f ',1,lenCH)),lenCH)'];
area=[area; fscanf(fid, strcat(repmat('%f ',1,lenCH)),lenCH)'];
for i=1:lenCH
    patron(i).tortuosidad=tortuosidad(i)
    patron(i).area=area(i)
    patron(i).areaBloques=fscanf(fid, strcat(repmat('%f ',1,seg-1)),seg-1)'
end
len_sw1=fscanf(fid, '%i',1);
len_sw2=fscanf(fid, '%i',1);
for i=1:lenCH
    featureClas=[];
    for j=1:len_sw1
        featureClas=[featureClas;fscanf(fid, strcat(repmat('%f ',1,len_sw2)),len_sw2)'];
    end
    sw(i).featureClas=featureClas
    sw(i).Variables=fscanf(fid, strcat(repmat('%f ',1,len_sw2)),len_sw2)';
    sw(i).indexFeatures=fscanf(fid, strcat(repmat('%i ',1,len_sw2)),len_sw2)';
end
bestAUC=[bestAUC; fscanf(fid, strcat(repmat('%f ',1,lenCH)),lenCH)'];

fclose(fid);

