clear all;close all;clc

% Example
%Generate sample data and define noise source paramerets
tc = gauspuls('cutoff',50e3,0.6,[],-40);
t = -tc : 1e-6 : tc;
s = gauspuls(t',50e3,0.6);
N=length(s);
M=50;
noise_sig=[10 20 1 10];
L=length(noise_sig);
%Define paramereters for the procedure
param.frat=0.001;
param.Npts=8;
param.blcks=10;
param.st=1;
param.nd=N;
param.art_th=inf;

%Generate data and call procedure
for i=1:L
    x=repmat(s,[1 M]) + randn(N,M).*noise_sig(i);
    init=(i==1);
    [atrials,average]=wnsfmp(x,init,param,'ave');
end

subplot(311)
plot(s,'g-');hold on;plot(average.sig,'b');plot(average.nsig,'r')
legend('Signal','Weighted Average','Normal Average')
title('Averaged Waveforms')
subplot(312)
plot(10*log10(average.resW),'b');hold on;plot(10*log10(average.resN),'r')
ylabel('Residual Noise Level (dB)')
xlabel('Trial Number')
title('Estimated Residual Noise Power')
legend('Weighted Average','Normal Average')
subplot(313)
noise_sig=repmat(noise_sig,[M 1]);
plot(noise_sig(:))
ylabel('Simulated Noise Power')
xlabel('Trial Number')

%%%%END OF EXAMPLE %%%