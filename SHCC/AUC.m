
function [AUCT]=AUC(diff)
%Para AUC de curvas ROC
[a,b]=size(diff)
AUCT=[];
for j=1:b-1
    [X,Y,T,AUC] = perfcurve(diff(:,b),diff(:,j),1);
    AUCT=[AUCT; 1-AUC];
end
AUCT=AUCT';