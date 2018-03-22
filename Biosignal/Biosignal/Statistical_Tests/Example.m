
%%%Montecarlo simulation for accuracy of randomness tests
clear all;clc
t=[0:1/1000:1];
N=1001;
x=sin(2*pi*t)+sin(4*pi*t)+sin(8*pi*t);
y=exp(0.01*[-1*[500:-1:1] 0 -1*[1:500]]);
s=x.*y;
N=500;
data=zeros(3,N);

for i=1:N,

    n=(0.000001)*(2^(i/20))*randn(1001,1);
    data(1,i)=20*log(std(s)/std(n));
    p=israndom(s'+n);
    data(2:3,i)=p;

end

plot(data(1,:),data(2,:))
hold on
plot(data(1,:),data(3,:),'r')
grid on
line([data(1,1) data(1,end)],[0.05 0.05])