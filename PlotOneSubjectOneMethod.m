function PlotOneSubjectOneMethod(channels,subject,grepts,nolegend)

if (nargin<4)
    nolegend=false;
end

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

% The structure of grepts is (subject, channel, numberofrepetitions)
% We are getting the mean on each channel and choosing the bigger and
% smaller
c = permute(grepts(subject,:,:),[1 3 2]);
d=reshape(mean(c),[],size(grepts,2),1);
[val,cmax] =max(d);
[val,cmin] =min(d);
cmax=cmax(1);
cmin=cmin(1);
hold on
r=zeros(1,size(grepts,2));
r(cmin) = 5;
r(cmax) = 8;

if (size(grepts,2)>8) || (~nolegend)
    cl=zeros(size(grepts,2),3);
    cl(cmin,:) = C(2,:);
    cl(cmax,:) = C(4,:);
else
    cl = C;
end




for channel=[cmin,cmax]
    resh=grepts(subject,channel,:);
    %C = permute(A,[1 3 2]);

    
    resh = reshape(resh,[],size(resh,2),1);
    plot(resh,'LineWidth',2,'MarkerSize',1,'color',cl(channel,:),...
    'linestyle',linestyle{mod(channel,8)+1},'marker',mark{mod(channel,8)+1});

    text(r(channel),resh(r(channel))+0.1,channels{channel});

    %plot(resh,'LineWidth',2,'MarkerSize',3,'color',C(channel,:),...
    %'linestyle',linestyle{channel},'marker',mark{channel});
end

%legend(channels{[cmin,cmax]});
hold off
end