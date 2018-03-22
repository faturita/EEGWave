function [b,a]=notch(fn,fs,r)
% 
% [b,a]=notch(fn,fs,r)
% 
% Generates a notch or resonator filter a frequency fn (Hz). 
% Parameters:
% 
% fn          -desired notch or peak for the filter
% fs          -sampling frequency
% r           -Gain of the pole used to push the frequency (0< r <1)
%              response up right after the notch (default=0.995)
% b           -Numerator of the filter (set b=1 if you want
%              to use it as  a resonator instead of noth filter
% a           -Denominator of the filter


% Ikaro Silva 2007
% 
% References:
% *Rangayyan (2002), "Biomedical Signal Analysis", IEEE Press Series in BME
% 
% *Hayes (1999), "Digital Signal Processing", Schaum's Outline

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


if(isempty(r))
    r = 0.995;   % Control parameter. 0 < r < 1.
end
cW = cos(2*pi*fn/fs); 
b=[1 -2*cW 1];
a=[1 -2*r*cW r^2];


