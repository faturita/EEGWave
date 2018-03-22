function se=std_err(sig,varargin)
% 
% Standard error for mean, proportion and estimates.
% Options are:
% 
% For standard error of mean:
%     
% se=std_err(sig,n,'mean')
% 
%   Where sig is standard deviation estimate, n number of samples.
% 
% For standard error of proportion
% 
% se=std_err(p,n,'proportion')
% 
%   Wher p is the percent of the proportion.
% 
% For standard error of estimates:
% 
% se=std_err(sig,n,'estimates',r)
% 
%   Where r is the correlation between the predictor and the estimate.
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


n=varargin(1);


switch varargin(2)
    
    case 'mean'
        se=sig/sqrt(n);
    case 'proportion'
        se=sqrt( (sig*(1-sig))/n );
    case 'estimate'
        r=varargin(3);
        se=sig*( (1-r^2)*( (n-1)/(n-2) ) )^0.5;
end
