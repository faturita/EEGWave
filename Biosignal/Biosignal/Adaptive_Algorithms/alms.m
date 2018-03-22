function  [y,w,err]=alms(x,varargin)
%    [y,w,err]=alms(x,d,w,step)
%
%     t=[0:1/1000:1];
%     N=1001;
%     d=sin(2*pi*t);
%     x=d+0.001*randn(N,1)';
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


[N,M]=size(x);

d=varargin{1};
p=length(varargin);

if(isempty(varargin{2}))
  wi=zeros(1,N);
  Q=N;
elseif isscalar(varargin{2})
    wi=zeros(1,varargin{2});
    Q=varargin{2};
else
    wi=varargin{2}; 
    Q=length(wi);
end
if(p<3)
  umax=1/(N*x'*x);  
  u=umax/100;
else
    u=varargin{3};
end


err=zeros(N,1);
w=wi;
y=zeros(N,1);

for j=1:N,
    if (j<Q+1)
        buff=zeros(Q,1);
        buff(1:j)=x(1:j);
        y(j)=w*buff;
        err(j)=d(j)- y(j);
        w=w + u*err(j)*buff';
    else
        y(j)=w*x(j-(Q-1):j);
        err(j)=d(j)-y(j);
        w=w + 2*u*err(j)*x(j-(Q-1):j)';
    end

end

    