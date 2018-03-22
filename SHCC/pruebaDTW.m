
%[Dist,D,k,w]=dtw(datos(1,:),datos(2,:))
t=[1 2 3 4 5 6 7 8];
a=[2 9 5 3 1 2 8 2];
b=[3 7 3 7 9 3 2 1];
subplot(4,1,1); plot(t,a)
subplot(4,1,2); plot(t,b)
aver=a+b./2
subplot(4,1,3); plot(t,aver)
[Dist,D,k,w]=dtw(a,b)
tmpl=(a(w(:,1))+b(w(:,2)))./2;
t=1:1:11
subplot(4,1,4); plot(t*-1,tmpl)
