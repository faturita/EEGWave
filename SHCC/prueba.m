clims = [-19 18];
canales=[1 3 6 9 8 10]

%for j=15:-1:1
j=13
%     for i=1:P
%         datos=[];
%         aleat=randperm(P,j)
%         for h=1:length(canales)
%             %datos=[datos; mean(ERPgral(etiqP300(aleat,2),:,canales(h)))];
%             datos=[datos; ERPgral(etiqP300(aleat,2),:,canales(h))];
%         end 
%         figure
%         imagesc(datos(:,40:120),clims)
%         set(gca,'XTick',[]) % Remove the ticks in the x axis!
%         set(gca,'YTick',[]) % Remove the ticks in the y axis
%         set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
%         saveas(gcf,['images/P300_' int2str(j) '_'  int2str(i)],'png')
%         close all
%     end
    for i=655:N
        datos=[];
        aleat=randperm(N,j)
        for h=1:length(canales)
            datos=[datos; mean(ERPgral(etiqNoP300(aleat,2),:,canales(h)))];
            %datos=[datos; ERPgral(etiqNoP300(aleat,2),:,canales(h))];
        end 
        figure
        imagesc(datos(:,40:120),clims)
        set(gca,'XTick',[]) % Remove the ticks in the x axis!
        set(gca,'YTick',[]) % Remove the ticks in the y axis
        set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
        saveas(gcf,['images/NP300_' int2str(j) '_' int2str(i)],'png')
        close all
    end
%end

