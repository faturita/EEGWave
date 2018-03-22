function [sw]=seleccionCaracteristicas(V,l,num_features)        

%seleccion de caracteristicas
        % stepwise models are locally optimal, but may not be globally
        % optimal. 
        [B,SE,PVAL,i] = stepwisefit(V,l,'maxiter',num_features,'display','off','penter',.1,'premove',.15);   
        %initialModel=repmat([true],238,1)'
        %[B,SE,PVAL,in] = stepwisefit(featureOrig,etiquetasOrig,'inmodel',initialModel,'display','off','penter',.1,'premove',.15);   
        indexFeatures=find(i~=0)
        Variables=B(indexFeatures)
        Variables=10*Variables/max(abs(Variables));
        %featureOrig=((20 P300)+(20 NoP300)) x (7 electrodos * 34
        %caracteristicas cada uno = 238)
        %featureClas=((20 P300)+(20 NoP300)) x seleccion de las caracteristicas
        %con todas las clases incluidas
        sw.Variables=Variables;
        sw.indexFeatures=indexFeatures;