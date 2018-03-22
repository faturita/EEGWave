function [err,w,lamb]=arls(x,d,nw,epsi,lamb,alph,lambmin,wi)
% 
% [err,w]=arls(x,d,nw,epsi,lamb,alph,lambmin,wi)
% 
% Adaptive RLS algorithm. Parameters are:
% x      (1xN) reference vector
% d      (1xN) reference vector
% nw     (1x1) number of taps in the filter
% epsi   (1x1) Regularization constraint
%              Use large value for low SNR and
%              a small value for high SNR.
% lamb  (1x1) Optional. Forgetting factor.With 
%             lamb=1, algorithm uses all the data
%             (as in stationary case). If left empty
%             the algorithm adapts until it converges
%             at an appropiate value.
% alph  (1x1) Required if lamb is left blank. This is
%             the learning rate at which lamb is
%             adapted (should be proportional to how quickly 
%             the environment is changing).
%             
% Ouput parameters:
% 
% err   (1xN)  The apriori learning curve of the RLS.
% w     (1xnw) The final RLS taps.
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
           


N=length(x);
if(isempty(epsi))
    epsi=10^-10;
end

if(isempty(wi))
    w=zeros(nw,1);
else
    w=wi;
end

P=eye(nw).*epsi;
err=zeros(1,N);
if(isempty(lamb))
    lamb=1;
    alamb=1;
    phi=zeros(nw,1);
    s=zeros(nw,nw);
    if(isempty(lambmin))
        lambmin=-inf;
    end
else
    alamb=0;
end


for i=1:N,
    
    if(i>=nw)
        u=x(i-nw+1:i)';
        pi=P*u;
        k=pi/(lamb + u'*pi);


        apri=d(i)-w'*u;
        w= w +k*conj(apri);
        P=(P - k*u'*P)./lamb;
        err(i)=apri;
        
        if(alamb)
            lamb= lamb + alph*real(phi'*u*apri);
            lamb=min(lamb,1);
            lamb=max(lamb,lambmin);
            s=((eye(nw)-k*u')*s*(eye(nw)-u*k')+k*k' -P )./lamb;
            phi=(eye(nw)-k*u')*phi + s*u*conj(apri);
        end
        
        
    end

end



