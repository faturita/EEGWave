routput=open('routput.mat');
routput = routput.routput;

EEG=open('EEG.mat')
EEG=EEG.EEG;

EEG(8,2,1)

for i=1:12 
    %figure;plot( routput{8}{2}{1}{i}(:,7) )
    %title(sprintf('Label %d',EEG(8,2,i).label));
end



template1=routput{8}{2}{1}{8};
template2=routput{8}{2}{1}{1};

f=figure;
set(0, 'DefaultAxesFontSize',15);
plot(template1);

axis([0 256 -10 10]);
%ylabel('Performance')
%set(hx,'fontSize',40);
%set(hy,'fontSize',40);
%set(gcf, 'Position', [1, 1, 730, 329])
ylabel('Microvolts')
xlabel('Sample points');
print(f, 'erptemplate1','-deps');

%title('Multichannel ERP Template');

