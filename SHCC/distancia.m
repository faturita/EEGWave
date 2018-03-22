function [dist]=distancia(template,ERP,tipo)
if tipo==1 %L1 (Manhattan)
	dist=sum(abs(template-ERP)); %Diferencia entre pendientes!!
elseif tipo==2
    P=[1:16; template]';
    Q=[1:16; ERP]';
    [dist, cSq] = DiscreteFrechetDist(P,Q);
%     figure
%     plot(Q(:,1),Q(:,2),'o-r','linewidth',3,'markerfacecolor','r')
%     hold on
%     plot(P(:,1),P(:,2),'o-b','linewidth',3,'markerfacecolor','b')
%     title(['Discrete Frechet Distance of curves P and Q: ' num2str(dist)])
%     legend('Q','P','location','best')
%     line([2 dist+2],[0.5 0.5],'color','m','linewidth',2)
%     text(2,0.4,'dFD length')
%     for i=1:length(cSq)
%       line([P(cSq(i,1),1) Q(cSq(i,2),1)],...
%            [P(cSq(i,1),2) Q(cSq(i,2),2)],...
%            'color',[0 0 0]+(i/length(cSq)/1.35));
%     end
%     axis equal
%     % display the coupling sequence along with each distance between points
%     disp([cSq sqrt(sum((P(cSq(:,1),:) - Q(cSq(:,2),:)).^2,2))])


elseif tipo==3 %LCS cadenas
    for i=1:10
        [dist(i), D, aLongestString]=LCS(template(i,:),ERP(i,:));
    end
end