function [p]=runstest(x)
% 
% [p]=runtest(x)
% 
% Runs test on x. p is the probability
% that the sequence x is random.
%
% For matrices, p is vector corresponding
% to tests performeed along the columns of x.
%
% %Example, Test if data is statinary on the mean
% x=[randn(100,1) randn(100,1)+1 randn(100,1) randn(100,1)+1 randn(100,1) randn(100,1)+1];
% X=mean(x)';
% p=runstest(X)
%  
% y=randn(100,6);
% Y=mean(y)';
% p=runstest(Y)

%Ikaro Silva 2007
%References:  
% *Challis, Kitney. (1990), "Biomedical Signal Processing- Part 1 Time Domain Methods",
% Med. & Biol Eng. & Comput.,28,509-524
% 
% *Schaum's Outline, Statistics
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

%%Runs Method%%%%
m=median(x);
seq=sign(x-repmat(m,[N 1]));
seq(seq==0)=[];
V=sum(diff(seq)~=0)+1;
N1=sum(seq>0);
N2=sum(seq<0);
h0V=(2.*N1.*N2./(N1+N2))+1;
varV=2.*N1.*N2.*(2.*N1.*N2-N1-N2)/( (N1+N2).^2 .* (N1+N2-1));
p=normcdf(V,h0V,sqrt(varV));


%Set all p equal symmetry (two tailed to one tail deviation )
p=1-(abs(p-0.5)+0.5);



