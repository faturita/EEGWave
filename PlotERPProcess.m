%%
figure;
set(0, 'DefaultAxesFontSize',15);
for subject=subjectRange
    subplot(4,6,(find(subjectRange==subject)-1)*6+1);PlotOneSubjectOneMethod(channels,subject,globalrepts1);if ((find(subjectRange==subject)-1)==0) title('MP 1');end;axis([0 10 0 1.05]);if (find(subjectRange==subject)~=size(subjectRange,2)) set(gca, 'XTickLabel', []);end;
    subplot(4,6,(find(subjectRange==subject)-1)*6+2);PlotOneSubjectOneMethod(channels,subject,globalrepts2);if ((find(subjectRange==subject)-1)==0) title('MP 2');end;axis([0 10 0 1.05]);set(gca, 'YTickLabel', []);if (find(subjectRange==subject)~=size(subjectRange,2)) set(gca, 'XTickLabel', []);end;
    subplot(4,6,(find(subjectRange==subject)-1)*6+3);PlotOneSubjectOneMethod(channels,subject,globalrepts3);if ((find(subjectRange==subject)-1)==0) title('SIFT');end;axis([0 10 0 1.05]);set(gca, 'YTickLabel', []);if (find(subjectRange==subject)~=size(subjectRange,2)) set(gca, 'XTickLabel', []);end;
    subplot(4,6,(find(subjectRange==subject)-1)*6+4);PlotOneSubjectOneMethod(channels,subject,globalrepts6);if ((find(subjectRange==subject)-1)==0) title('PE');end;axis([0 10 0 1.05]);set(gca, 'YTickLabel', []);if (find(subjectRange==subject)~=size(subjectRange,2)) set(gca, 'XTickLabel', []);end;
    subplot(4,6,(find(subjectRange==subject)-1)*6+5);PlotOneSubjectOneMethod(channels,subject,globalrepts7);if ((find(subjectRange==subject)-1)==0) title('SHCC');end;axis([0 10 0 1.05]);set(gca, 'YTickLabel', []);if (find(subjectRange==subject)~=size(subjectRange,2)) set(gca, 'XTickLabel', []);end;
    subplot(4,6,(find(subjectRange==subject)-1)*6+6);PlotOneSubjectOneMethod(channels,subject,globalrepts4);if ((find(subjectRange==subject)-1)==0) title('SVM');end;axis([0 10 0 1.05]);set(gca, 'YTickLabel', []);if (find(subjectRange==subject)~=size(subjectRange,2)) set(gca, 'XTickLabel', []);end;
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
C(7,:)=[0.5 0.5 0.25];
C(8,:)=[1 0.5 0.15];


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
ylabel('Performance','visible','on');
xlabel('Repetitions','visible','on');

