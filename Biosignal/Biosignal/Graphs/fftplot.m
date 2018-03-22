function [varargout]=fftplot(varargin)
%
%[Pxx,f]=fftplot(x,nfft,Fs,scale,show,clr)
%
% 
% _______________________________________________________________________________
% Copyleft (l) 2010 by Ikaro Silva, All Rights Reserved
% Contact Ikaro Silva (ikarosilva@ieee.org)
% 
%    This library (Biosignal Toolbox) is free software; you can redistribute
%    it and/or modify it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
% 
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
% 
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
%    02111-1307  USA
% 
% _______________________________________________________________________________



%Initialize Input Parameter Names and Default values
tmp=2^(nextpow2(varargin{1})); %Use next highest power of 2 greater than or equal to length(x) to calculate FFT. 
in_params={'x,nfft,Fs,scale,show,clr'};
in_params_default={varargin{1},tmp,[],1,[],[0.5 0.5 0.5]};
get_varargin(in_params,in_params_default,varargin);



% Take fft, padding with zeros so that length(fftx) is equal to nfft
fftx = fft(x,nfft); 

% Calculate the numberof unique points 
NumUniquePts = ceil((nfft+1)/2); 

% FFT is symmetric, throw away second half 
fftx = fftx(1:NumUniquePts); 

% Take the magnitude of fft of x and scale the fft so that it is not a function of 
% the length of x 
mx = abs(fftx)/length(x); 

% Take the square of the magnitude of fft of x. 
mx = mx.^2;

% Since we dropped half the FFT, we multiply mx by 2 to keep the same energy.
% The DC component and Nyquist component, if it exists, are unique and should not
% be mulitplied by 2.
if rem(nfft, 2) % odd nfft excludes Nyquist point
  mx(2:end) = mx(2:end)*2;
else
  mx(2:end -1) = mx(2:end -1)*2;
end

if(scale)
    %normalize the power to peak at 1
    mx=mx./max(mx);
end

% This is an evenly spaced frequency vector with NumUniquePts points.
f = linspace(0,1,NumUniquePts); %normalized frequency

%Convet frequency vector to Hertz if Fs is passed in
if(~isempty(Fs))
    f=f.*(Fs/2);
end

%Convert power to dB
mx=10*log10(mx);

% Generate the plot, title and labels.
if(~isempty(show))
    switch lower(show)
        case 'logylogx'
            semilogx(f,mx,'Color',clr);
        case {'logylinx','logxliny'}
            plot(f,mx,'Color',clr);
        case 'linylinx'
            plot(f,10.^(mx./10),'Color',clr);
        case {'linylogx','linxlogy'}
            semilogx(f,10.^(mx./10),'Color',clr);
            
    end
    title('Power Spectrum (dB)');
    ylabel('Power (dB)');
    grid on
    if(isempty(Fs))
        xlabel('Normalized Frequency');
    else
        xlabel('Frequency');
    end

end




%Pass back the outputs if requested
if(nargout  >= 1)
    varargout(1)={mx};
    if(nargout >= 2)
        varargout(2)={f};
    end
end

