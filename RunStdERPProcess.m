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
globalrandomamplitude=true;
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
    clear globalspellerrep
for globalrepetitions=1:10
    
    % MP1

    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=5;
    run('ERPProcess.m')
    globalrepts1=globalspellerrep;
    
end
    clear globalspellerrep
for globalrepetitions=1:10
    
    % MP 2

    globalappyzscore=false;
    globalclassifier=11;
    globalfeaturetype=4;
    run('ERPProcess.m')
    globalrepts2 = globalspellerrep;
end
    clear globalspellerrep
for globalrepetitions=1:10    
    % SIFT
    globalappyzscore=true;
    globalclassifier=6;
    globalfeaturetype=1;
    globaldistancetype='cosine';
    run('ERPProcess.m')
    globaldistancetype='euclidean';
    globalrepts3 = globalspellerrep;
end
    clear globalspellerrep
for globalrepetitions=1:10    
    % PE
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=6;
    globalm=2;globalwindowsize=10;
    run('ERPProcess.m')
    globalrepts6 = globalspellerrep;
end
    clear globalspellerrep
for globalrepetitions=1:10    
    % SHCC
    globalappyzscore=false;
    globalclassifier=6;
    globalfeaturetype=7;
    run('ERPProcess.m')
    globalrepts7 = globalspellerrep;
end
clear globalspellerrep
for globalrepetitions=1:10   
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
    subplot(4,6,(find(subjectRange==subject)-1)*6+2);PlotOneSubjectOneMethod(channels,subject,globalrepts2);if ((find(subjectRange==subject)-1)==0) title('MP 2');end;axis([0 10 0 1.05]);set(gca, 'YTickLabel', []);if (subject ~= 26) set(gca, 'XTickLabel', []);end;
    subplot(4,6,(find(subjectRange==subject)-1)*6+3);PlotOneSubjectOneMethod(channels,subject,globalrepts3);if ((find(subjectRange==subject)-1)==0) title('SIFT');end;axis([0 10 0 1.05]);set(gca, 'YTickLabel', []);if (subject ~= 26) set(gca, 'XTickLabel', []);end;
    subplot(4,6,(find(subjectRange==subject)-1)*6+4);PlotOneSubjectOneMethod(channels,subject,globalrepts6);if ((find(subjectRange==subject)-1)==0) title('PE');end;axis([0 10 0 1.05]);set(gca, 'YTickLabel', []);if (subject ~= 26) set(gca, 'XTickLabel', []);end;
    subplot(4,6,(find(subjectRange==subject)-1)*6+5);PlotOneSubjectOneMethod(channels,subject,globalrepts7);if ((find(subjectRange==subject)-1)==0) title('SHCC');end;axis([0 10 0 1.05]);set(gca, 'YTickLabel', []);if (subject ~= 26) set(gca, 'XTickLabel', []);end;
    subplot(4,6,(find(subjectRange==subject)-1)*6+6);PlotOneSubjectOneMethod(channels,subject,globalrepts4);if ((find(subjectRange==subject)-1)==0) title('SVM');end;axis([0 10 0 1.05]);set(gca, 'YTickLabel', []);if (subject ~= 26) set(gca, 'XTickLabel', []);end;
end
axis([0 10 0 1.05]);
%ylabel('Performance')
%set(hx,'fontSize',40);
%set(hy,'fontSize',40);
set(gcf, 'Position', [1, 1, 730, 329])

C(1,:)=[1 0 1];
C(2,:)=[1 0 0];
C(3,:)=[0 0.5 0];
C(4,:)=[0 0 1];
C(5,:)=[0.5 0.5 0.5];
C(6,:)=[0.5 0 0.5];
C(7,:)=[0 0.75 0.2];
C(8,:)=[0.65 0.30 0];


mark=cell(8,1);
mark{1}='o';
mark{2}='s';
mark{3}='^';
mark{4}='v';
mark{5}='>';
mark{6}='<';
mark{7}='p';
mark{8}='d';

linestyle={'-','--',':','-.',':','--','-','-.'};

hold on
h = zeros(8, 1);
for channel=channelRange
    h(channel) = plot(NaN,NaN,'LineWidth',2,'MarkerSize',1,'color',C(channel,:),...
    'linestyle',linestyle{channel},'marker',mark{channel});
end
legend(h, channels);