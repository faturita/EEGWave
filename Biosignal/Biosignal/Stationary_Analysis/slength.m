function [sl]=slength(x,varargin)
% 
% [sl]=slength(x,w)
% 
% Computes the signal length of x. If w is empty the default
% is the centroidal time instant of x^2. x and w are both row
% vectors.
%
%
%%Example
% clear all;clc
% t=[0:1/1000:1];
% N=1001;
% x=sin(2*pi*t)+sin(4*pi*t)+sin(8*pi*t);
% y=exp(0.01*[-1*[500:-1:1] 0 -1*[1:500]]);
% s=x.*y;
% [trash,z]=rceps(s); %Generates minimum phase version of signal 
% sl=slength(s')
% sl2=slength(z')

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
if(isempty(varargin))
    w=[1:N];
else
    w=varargin{1};
end

sl= (w*(x.^2))./diag(x'*x)';