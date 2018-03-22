function [signal]=meanERP(ERP,t,seg,ctipo,mtipo,print,name)
switch mtipo
    case 1 %Promediacion P2P
        ERPprom=mean(ERP,1);
    case 2 %Correlacion cruzada Woody
        ERPprom=woody(ERP',[],[],'woody','biased');
    case 3 %DTW
        [tiempoWarp,ERPprom]=templateDTW(t,ERP,seg,print);
end
[signal]=chainCode(t,ERPprom,ctipo,seg,print,[name num2str(1)]); 
signal.ERPprom=ERPprom;


        





