function [d]=sem(x,nwin,p,ref_win)
%
%     [d]=sem(x,nwin,p,ref_win)
% 
% Computes the SEM (spectral error measure) distance in the signal
% x with window size nwin modeled by p poles. The SEM distance d is a moving measure of 
% nonstationarity in the signal x.
% 
%
%For more details see "Biomedical Signal Analysis: A Case Study Approach",
%Rangayyan
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
[a,e0] =lpc(x(1:ref_win),p);
d=zeros(1,N);
est_x = filter([0 -a(2:end)],1,x(1:nwin));   % Estimated signal
ef= x(1:nwin) - est_x;  
[acs_f,lags] = xcorr(ef);
mR0=round(length(acs_f)/2);


for i=1:N-nwin

    est_x2 = filter([0 -a(2:end)],1,x(i:i+nwin-1));   % Estimated signal
    e2 = x(i:i+nwin-1) - est_x2;                       %Prediction error
    [acs_var,lags] = xcorr(e2);        % fixed acs
    mRv=round(length(acs_var)/2);


    d(i)= (acs_f(mR0)/acs_var(mRv)-1).^2 + 2*sum(acs_f(mR0+1:end)./acs_var(mRv+1:end));


end

