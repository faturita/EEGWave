function [b,a]=reson(fn,fs,K,mthd)
% 
% [b,a]=reson(fn,fs,K,mthd)
% 
% Generates a resonant (single pole) filter.Parameters are:
% 
% fn      - desired location of pole (Hz)
% fs      - sampling frequency (Hz)
% K       - Q factor or pole magnitude(depending on witch method used
%           in the mthd parameter described below)
% mthd    - (string) desired method to use. Options are:
% 
%             'poleMag' : in this case K specifies the magnitude of the pole in the filter
%                         (0 < K <1). Notice that the gain might not be equal to 1 at the resonant
%                         peak. And this method might provide *less* attenuaton at the sidebands than
%                         method using 'Q2' below.
%                         
%             'Q1'      : simple method utilizing a second order feedback system. K specificies
%                         the filter's Q (how narrow the filter is). This method has significant 
%                         drawbacks, use Q2 instead.
%                         
%             'Q2'     : improved version of Q1 with more symetrical response and unit gain at desired
%                        pole location (see example).
% 
% b       - filter FIR taps
% a       - filter AR taps
% 
% 
% %Example
% fs=5000;
% fn=50;
% K=50;
% r=0.997;
% [b1,a1]=reson(fn,fs,K,'Q1');
% [b2,a2]=reson(fn,fs,K,'Q2');
% [b3,a3]=reson(fn,fs,r,'poleMag');
%
% [H1,F]=freqz(b1,a1,500,fs);
% hold on;
% [H2,F]=freqz(b2,a2,500,fs);
% [H3,F]= freqz(b3,a3,500,fs);
%  plot(F,20*log10(abs(H1)));hold on;grid on
%  plot(F,20*log10(abs(H2)),'r')
%  plot(F,20*log10(abs(H3)),'g')
% legend('Q1','Q2','PoleMag')

%Written By Ikaro Silva 2008
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

switch mthd

    case 'poleMag'
        cW = cos(2*pi*fn/fs);
        b=[1];
        a=[1 -2*K*cW K^2];

    case 'Q1'
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Puts a pole exatly on the unit circle
        % at the fn Hz line.
        
        %Not recommended!!! Use Q2 instead
        cW =2*cos(2*pi*fn/fs);
        Hn=[1 -cW 1];
        b=[1];
        a=[1 K.*Hn];

    case 'Q2'

        %Similar  to 'Q1' but more accurate
        %For details see IEEE SP 2008 (5), pg 113
        beta=1+K;
        f=pi*fn/fs;

        numA=tan(pi/4 - f);
        denA=sin(2*f)+cos(2*f)*numA;
        A=numA/denA;

        b=[1 -2*A A.^2];
        a=[ (beta + K*(A^2)) -2*A*(beta+K) ((A^2)*beta + K)];

end






