function [difpend,tortuosidad,m]=SCC_pendiente(x,y)
% figure;
% axis equal
% hold all
[pendientes]=dibujoCurva(x(2:end),y(2:end),0,0);


t=length(x)-1;

beta=zeros(1,t);
m=zeros(1,t);
z=zeros(1,t);

deltaX=zeros(1,t);
deltaY=zeros(1,t);

for i=1:t
   deltaX(i)=x(i)-x(i+1);
   deltaY(i)=y(i)-y(i+1);
end
len=length(x)
for i=2:len 
   h(i-1)= sqrt((x(i)-x(i-1))^2+(y(i)-y(i-1))^2);
end
h
t=length(deltaX);
for i=2:t
    beta(i)=acos(((deltaX(i)*deltaX(i-1)) + (deltaY(i)*deltaY(i-1)) )/(h(i)*h(i-1)));
    z(i)=(deltaY(i)*deltaX(i-1)) - (deltaX(i)*deltaY(i-1));
    
    if z(i)>=0;
        m(i)=beta(i)/pi;
    else
        m(i)=-beta(i)/pi;
    end
    if isnan(m(i))==1
        m(i)=m(i-1);
    end
%     text(x(i),y(i)-0.02,num2str(m(i)));
end
hold off

recibePendientes(m);
difpend=sum(m)
tortuosidad=sum(abs(m))


