clear all
close all

globalrepts1=[];
globalrepts2=[];
globalrepts3=[];
globalrepts6=[];
globalrepts7=[];
globalrepts4=[];

globalclassifier=Classifiers.nn;
globalfeaturetype=Features.multichannel;
globalrepetitions=10;
globalapplyzscore=false;
globalrandomdelay=false;
globalrandomamplitude=false;
globaldistancetype='euclidean';
globalk=7;
globalsignalgain=2.2;
globalsignalsize=64;
globalsubjectrange=[21,24,25,26];
%globalsubjectrange=[3,4,6,7];
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
    globaldistancetype='cosine';
    run('ERPProcess.m')
    globaldistancetype='euclidean';
    globalrepts3 = globalspellerrep;
    
    % PE
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=6;
    globalm=2;globalwindowsize=10;
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

%%
figure;
set(0, 'DefaultAxesFontSize',15);
for subject=subjectRange
    subplot(4,6,(find(subjectRange==subject)-1)*6+1);PlotOneSubjectOneMethod(channels,subject,globalrepts1);if ((find(subjectRange==subject)-1)==0) title('MP 1');end;axis([0 10 0 1.05]);if (subject ~= 26) set(gca, 'XTickLabel', []);end;
    subplot(4,6,(find(subjectRange==subject)-1)*6+2);PlotOneSubjectOneMethod(channels,subject,globalrepts2);if ((find(subjectRange==subject)-1)==0) title('MP 2');end;set(gca, 'YTickLabel', []);if (subject ~= 26) set(gca, 'XTickLabel', []);end;
    subplot(4,6,(find(subjectRange==subject)-1)*6+3);PlotOneSubjectOneMethod(channels,subject,globalrepts3);if ((find(subjectRange==subject)-1)==0) title('SIFT');end;set(gca, 'YTickLabel', []);if (subject ~= 26) set(gca, 'XTickLabel', []);end;
    subplot(4,6,(find(subjectRange==subject)-1)*6+4);PlotOneSubjectOneMethod(channels,subject,globalrepts6);if ((find(subjectRange==subject)-1)==0) title('PE');end;set(gca, 'YTickLabel', []);if (subject ~= 26) set(gca, 'XTickLabel', []);end;
    subplot(4,6,(find(subjectRange==subject)-1)*6+5);PlotOneSubjectOneMethod(channels,subject,globalrepts7);if ((find(subjectRange==subject)-1)==0) title('SHCC');end;set(gca, 'YTickLabel', []);if (subject ~= 26) set(gca, 'XTickLabel', []);end;
    subplot(4,6,(find(subjectRange==subject)-1)*6+6);PlotOneSubjectOneMethod(channels,subject,globalrepts4);if ((find(subjectRange==subject)-1)==0) title('SVM');end;set(gca, 'YTickLabel', []);if (subject ~= 26) set(gca, 'XTickLabel', []);end;
end
axis([0 10 0 1.05]);
%ylabel('Performance')
%set(hx,'fontSize',40);
%set(hy,'fontSize',40);
set(gcf, 'Position', [1, 1, 730, 329])