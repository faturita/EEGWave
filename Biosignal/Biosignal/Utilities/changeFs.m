function [y,fsnew,varargout]=changeFs(x,Fsold,Fsnew,varargin)
%
% [y,fsnew,p,q]=changeFs(x,Fsold,Fsnew,p,q)
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

if(Fsold==Fsnew)
    y=x;
    fsnew=Fsnew;
    return
end

if(nargin>3)
    p=varargin{1};
    q=varargin{2};
else
    pq=Fsnew/Fsold;
    [p,q]=find_rat(pq);
end

[y]=resample(x,p,q);
fsnew=Fsold*p/q;

if(nargout>2)
    varargout(1)={p};
    varargout(2)={q};
end
    




function [p,q]=find_rat(pq,varargin)
% 
% [p,q,err]=find_rat(pq,Nmax)
% 
% Finds the integers p and q for which their ratio is closest
% to pq (ie, p/q ~=pq);

if(nargin>1)
    Nmax=varargin{1};
else
    Nmax=600;
end


[pp,qq]=meshgrid([1:Nmax]);
pp=pp(:);
qq=qq(:);
[trash,ind]=min(abs(pq-pp./qq));

p=pp(ind);
q=qq(ind);

