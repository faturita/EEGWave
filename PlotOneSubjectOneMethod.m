function PlotOneSubjectOneMethod(channels,subject,grepts)
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

c = permute(grepts(subject,:,:),[1 3 2]);
d=reshape(mean(c),[],8,1);
[val,cmax] =max(d);
[val,cmin] =min(d);
hold on
for channel=[cmin,cmax]
    resh=grepts(subject,channel,:);
    %C = permute(A,[1 3 2]);

    resh = reshape(resh,[],size(resh,2),1);
    plot(resh,'LineWidth',1,'MarkerSize',1,'color',C(channel,:),...
    'linestyle',linestyle{channel},'marker',mark{channel});
    %plot(resh,'LineWidth',2,'MarkerSize',3,'color',C(channel,:),...
    %'linestyle',linestyle{channel},'marker',mark{channel});
end
%legend(channels{[cmin,cmax]});
hold off
end