function [theta,varargout]=least_sqfit(varargin)
%
%[theta,H,p,yhat]=least_sqfit(y,P,mode,x,sig,show,W,C)
%
%%Example 1
%y=[-0.4621 -0.3772 -0.1857 -0.1150 -0.0902 -0.0624 0.0391 ...
%   0.0016 0.1276 0.1517 0.1415 0.2349 0.2792 0.3171]';
%[theta,H,p,yhat]=least_sqfit(y,3,'poly',[],6,'r')
% 
% %Example 2
% N=100;
% Fs=48000;
% tm=linspace(0,N./Fs,N);
% signal=sin(2*pi*1000*tm)+sin(4000*pi*tm)+sin(8000*pi*tm);
% w=exp(0.1*[-1*[N/2:-1:1] 0 -1*[1:(N/2)-1]]);
% sig=0.001;
% y=(signal.*w)' + randn(N,1)*sqrt(sig);
% [theta,H,p,yhat]=least_sqfit(y,5,'poly',tm,sig,'r')
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
% 

%Function signature, default values, catch input trait, and error to throw
in_params={'y,P,mode,x,sig,show,W,C'};
in_params_default={varargin{1},varargin{2},varargin{3},[],[],[],[],[]};

%Call get_varargin which populates the function, catches, and throws errors
%based on inputs and conditions in in_params_catch
in_params_err=get_varargin(in_params,in_params_default,varargin);


[N,M]=size(y);
if(isempty(x))
    x=[1:N];
end


if(isempty(W))
    W=eye(N);
end
[Nw,Mw]=size(W);
if(Mw ==1)
    W=diag(W);
end

x=x(:); %convert to row vector

switch lower(mode)

    case 'poly'
        H=(repmat(x,[1 P])).^repmat([0:P-1],[N 1]);
        
    case 'exp'
      H=(repmat(x,[1 P])).^repmat([0:P-1],[N 1]);
        
    case 'complex'
        T=mean(diff(x));
        %In this case P is the angular frequencies (wn)
        z=exp(j*T.*P);
        H=(repmat(z(:)',[N 1])).^repmat([0:N-1]',[1 length(P)]);
        
    otherwise
        error('umimplemented')
end

%Calculate the least squares estimate
% [u,s,v]=svd(H'*H);
% theta=u*(s.^-1)*v'*H'*y(:);

%Calculate inverse of the projection and normal LS estimate
iH=inv(H'*W*H);
theta=iH*H'*W*y(:);

%Calculate constrainted LS estimate
if(~isempty(C))
    c=C(:,end);
    C(:,end)=[];
    theta=theta + iH*C*inv(C'*iH*C)*(c-C'*theta);
end
    
    
if(~isempty(show))
    plot(x,y)
    hold on;grid on
    plot(x,H*theta,show)
end
    

if(nargout>1)
    varargout(1)={H};
    if(nargout>2)
        yhat=H*theta;
        n=y-yhat;
        if(isempty(sig))
            sig=var(n);
            p=chi2cdf(n'*n/sig,N-P);
        else
            sig=var(n);
            p=chi2cdf(n'*n/sig,N-P);
        end
        varargout(2)={p};
        if(nargout >3)
            varargout(3)={yhat};
        end
    end
end





