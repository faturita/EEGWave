
clear all;close all;clc

%Example 1
y=[-0.4621 -0.3772 -0.1857 -0.1150 -0.0902 -0.0624 0.0391 ...
  0.0016 0.1276 0.1517 0.1415 0.2349 0.2792 0.3171]';

y(6)=-0.3;
y(7)=-1.5;
y(8)=-0.5;
y(9)=-0.3;
W=ones(14,1);
%W(6)=0.3;
%W(7)
W(8)=0.00005;
W=W./sum(W);
P=6;
mthd='poly';
x=[];
sig=[];
show='r';

[yhat,w,theta]=mono_poly(y,P);

x=[1:length(y)]';
x2=[1:0.1:length(y)]';

p=polyfit(x,y,P)
yhat=polyval(p,x)



dp=p(1:end-1).*[P:-1:1];
ddp=dp(1:end-1).*[P-1:-1:1];

dyhat=polyval(dp,x2);
ddyhat=polyval(ddp,x2);

plot(y)
hold on;grid on
%plot(yhat,'g')
%plot(x2,dyhat,'--k')
%plot(x2,ddyhat,'--g')

%Find roots of the polynomial at zero derivative
rs=roots(ddp)

xtreme=polyval(dp,rs)
poly_lift=xtreme-min(xtreme);

C=eye(P);
Pn=ceil(P/2);
c=[zeros(1,Pn);ones(1,(Pn))];
c=c(:);
if(mod(P,2))
    c(end)=[];
end


C=[C c];
[theta,H,p,yhat]=least_sqfit(y,P,mthd,x,sig,show,W,[]);
% 
% 
% %D: rxp
% %H: nxp
% Ny=length(y);
% 
% %derivative linear model for the polynomial
% D=[zeros(Ny,1) H(:,1:end-1)].*repmat([0:P-1],[length(y) 1]);
% % D2=[zeros(Ny,1) H(:,1:end-1)].*repmat([0 [0:P-1]],[length(y) 1]);
% 
% z=D*theta
% hold on
% plot(z,'--k')