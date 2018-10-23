globalrepts1=[];
globalrepts2=[];
globalrepts3=[];
globalrepts6=[];
globalrepts7=[];
globalrepts4=[];


globalrepetitions=10;
globalapplyzscore=true;
globalclassifier=Classifiers.svm;
globalfeaturetype=Features.singlechannel;
globalrandomdelay=false;
globalrandomamplitude=false;
globaldistancetype='cosine';
globalk=7;
globalsignalgain=2.2;
globalsignalsize=64;
globalsubjectrange=[21,24,25];
globalks= [37; -1;...
     16;    13;  -1;  45;    47; -1; 35; 31; 28;...
     -1; 39;    35;...
     -1; 50;...
     37;...
     43;    36;    33;...
     28;...
     29;...
     39; 28; 28; 28];
%run('ERPProcess.m')

for globalrepetitions=1:10
    
    % MP1
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=5;
    run('ERPProcess.m')
    globalrepts1=globalspellerrep;

%     c = permute(globalspellerrep(25,:,:),[1 3 2]);
%     d=reshape(mean(c),[],8,1);
%     [val,cmax] =max(d);
%     [val,cmin] =min(d);
%     
%     figure;
%     hold on;        
%     for channel=[cmin,cmax]
%         resh=globalspellerrep(25,channel,:);
%         %C = permute(A,[1 3 2]);
% 
%         resh = reshape(resh,[],size(resh,2),1);
%         plot(resh);
%     end
%     legend(channels{[cmin,cmax]});
%     hold off
    
    % MP 2
    globalappyzscore=false;
    globalclassifier=11;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalrepts2 = globalspellerrep;
    
    % SIFT
    globalappyzscore=true;
    globalclassifier=6;
    globalfeaturetype=1;
    run('ERPProcess.m')
    globalrepts3 = globalspellerrep;
    
    % PE
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=6;
    run('ERPProcess.m')
    globalrepts6 = globalspellerrep;
    
    % SHCC
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=7;
    run('ERPProcess.m')
    globalrepts7 = globalspellerrep;
    
    % SVM 
    globalappyzscore=false;
    globalclassifier=4;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalrepts4 = globalspellerrep;

end


