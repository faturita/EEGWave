function [varargout]=harmonic_recon(varargin)
%
%[xhat,mse,theta,theta_curve,b,a,amp,err]=harmonic_recon(x,Fs,P,theta,mu,r,M)
%
%
% Reconstructs a signal based on it's harmonic components estimated through the
% harmonic_est function. Arguments are:
%
% Input:
%
% x        - (Nx1 required) signal to be estimated.
% Fs       - (1x1 required) Sampling frequency (Hz).
% P        - (1x1 required) Number of initial harmonics to used to estimate the
%            fundamental frequency. Once the fundamental is estimated the
%            signal is reconstructed with harmonics up to the nyquist rate.
% theta    - (1x1 optional) Initial estimate of the fundamental frequency (Hz).
% mu       - (1x1 optional) Step size for the harmonic_est function.
% r        - (1x1 optional) Controls the 'width' of the nulls used in the harmonic_est
%             function.
% M        - (1x1 optional) Scalar number of samples from which to compute xhat
%            (default is N, same size as x).
% Outputs:
%
% xhat          - (Nx1 required) Reconstructed signal from harmonics.
% mse           - (1x1 optional) Mean square error.
% theta         - (1x1 optional) Final fundamental frequency estimate.
% theta_curve   - (Nx1 optional) Learning curve of the fundamental estimate (useful
%                 for checking convergence of the algorithm).
% b             - (Pmx1 optional) Comb filter MA coefficients.
% a             - (Pmx1 optional) Comb filter AR coefficients.
% amp           - (Pmx1 optional) Amplitude of harmonic components
%
%
%
% % Example
% load ecg_ex
% theta=1.8*pi*2/Fs;
% tm=[0:1/Fs:(length(x)-1)/Fs]';
% mu=10^-10;
% r=0.9;
% P=25;
% N=length(x);
% M=1.5*N;
% [xhat,mse,theta,theta_curve,b,a,amp]=harmonic_recon(x,Fs,P,theta,mu,r,M);
%
%
% figure
% subplot(211)
% plot(xhat)
% hold on
% plot(x,'r')
% legend('Recon','True Sig')
%
% subplot(212)
% title('Spectral Analysis')
% Ff=[1:length(amp)].*theta;
% stem(Ff,amp./max(amp),'b-o')
% hold on;grid on
% [Pxx,Ff]=pwelch(x,ones(length(x),1),0,[],Fs);
% plot(Ff,sqrt(Pxx)./max(sqrt(Pxx)),'r')
% legend('Estimated Harmonics', 'Estimated Signal Spectrum')
%
%
%
%
%  Writen by Ikaro Silva 2010 version 1.0.1
%

x=varargin{1};
[N,L]=size(x);
Fs=varargin{2};
P=varargin{3};
theta=[];
mu=10^-10;
r=0.9;
M=N;
if(nargin>=4 && ~isempty(varargin{4}))
    theta=varargin{4};
end
if(nargin>=5 && ~isempty(varargin{5}))
    mu=varargin{5};
end
if(nargin>=6 && ~isempty(varargin{6}))
    r=varargin{6};
end
if(nargin>=7 && ~isempty(varargin{7}))
    M=varargin{7};
end


%Estimate Harmonics
[theta,theta_curve,b,a,err]=harmonic_est(x,P,Fs,theta,mu,r);

mx=mean(x);
x=x-mx;
tm=[0:1/Fs:(M-1)/Fs]';
xhat=0;
Pm=floor(Fs/(2*theta));
y=zeros(M,1);
amp=zeros(Pm,1);
for p=1:Pm
    sig=cos(2*pi*tm(1:N)*p*theta);
    [R,lag]=xcorr(sig,x);
    [trash,dly]=max(R);
    phi=lag(dly)/Fs;
    sig=cos(2*pi*(tm+phi)*p*theta);
    amp(p)=sig(1:N)'*x./(sig(1:N)'*sig(1:N));
    sig=amp(p).*sig;
    y=y + sig;
end

vx=std(x);
vy=std(y);
y=y.*vx/vy;
y=y+mx;
varargout(1)={y};


if(nargout>1)
    mse=mean((y(1:N)-x(1:N)).^2);
    varargout(2)={mse};
end
if(nargout>2)
    varargout(3)={theta};
end
if(nargout>3)
    varargout(4)={theta_curve};
end
if(nargout>4)
    varargout(5)={b};
end
if(nargout>5)
    varargout(6)={a};
end
if(nargout>6)
    varargout(7)={amp};
end
if(nargout>7)
    varargout(8)={err};
end










