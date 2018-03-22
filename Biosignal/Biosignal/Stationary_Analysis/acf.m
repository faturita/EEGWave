function [d]=acf(x,nwin)
%
%     [d]=acf(x,nwin)
% 
% Computes the ACF (autocorrelation function) distance in the signal
% x with window size nwin. The ACF distance d is a moving measure of 
% nonstationarity in the signal x.
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



N=length(x);

R0=xcorr(x(1:nwin));
mR0=round(length(R0)/2);
[trash,zR0]=find([0 diff(sign(R0))]==-1);
[trash,qR0]=min(abs(zR0-mR0));

d=zeros(2,N);

for i=1:N-nwin

        Rv=xcorr(x(1+i:nwin+i));
        mRv=round(length(R0)/2);
        [trash,zRv]=find([0 diff(sign(Rv))]==-1);
        [trash,qRv]=min(abs(zRv-mRv));

        dp=(abs(sqrt(Rv(mRv)) - sqrt(R0(mR0)))) / min(sqrt(Rv(mRv)),sqrt(R0(mR0)));

        df=sum(abs(Rv-R0))/(0.5 + sum(min([Rv(:);R0(:)],[],2)));

        d(1,i+nwin)=dp;
        d(2,i+nwin)=df;


end

