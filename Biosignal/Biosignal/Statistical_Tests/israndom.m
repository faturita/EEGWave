function [p]=israndom(x)
% 
% [p]=israndom(x)
% 
% Non-parametric test for randomness.
% Gives the probability p (ie, significance) that a sequence (vector) x belongs 
% to a random process. 
% 
% The output p is a row
% vector with 2 elements. The first element is the probability 
% obtained using the Turning Points Methods and the second element
% is the probability obtained using the Runs Method. 
% 
% If x is a matrix the test results in a non-parametric Runs test 
% for the Null hypothesis of a all columns belonging to the same group.
%
% %Example
% %random signal
% x=randn(256,1);
% israndom(x)
% 
% %sine wave
% x=sin(2*pi.*[0:0.005:1]');
% israndom(x)

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

if(M>1)
    disp('***Comparing Groups (in ISRANDOM)***');
    buff=[x(:) reshape(repmat([1:M],[N 1]),[M*N 1])];
    y=sortrows(buff,1);
    [ind]=find(diff([y(:,1) ; NaN])~=0);

    %Debug Tip -> checking alignemnt: [y diff([y(:,1) ; NaN])~=0]

    %Mix em up
    if(~isempty(ind))

        %First Block is special
        blck=y(1:ind(1),2);
        y(1:ind(1),2)=blck(randperm(length(blck)));

        for i=2:length(ind)
            blck=y(ind(i-1)+1:ind(i),2);
            y(ind(i-1)+1:ind(i),2)=blck(randperm(length(blck)));
        end

    end
    
    %clear missing data
    y(isnan(y),:)=[];
    x=y(:,2);
 
end % of M >1



%%%%Turning Points Method%%%%

%Calculate turning points
T=sum((diff(sign(diff(x))))~=0);
h0T=(2/3)*(N-2);
varT=(16*N-29)/90;
p(1)=normcdf(T,h0T,sqrt(varT));



%%%Runs Method%%%%
m=median(x);
if(any(m==unique(x)))
    m=mean(x);
    disp('Using Mean instead of Median (in ISRANDOM)')
end
    
seq=sign(x-m);
seq(seq==0)=[];
V=sum(diff(seq)~=0)+1;
N1=sum(seq>0);
N2=sum(seq<0);
h0V=(2*N1*N2/(N1+N2))+1;
varV=2*N1*N2*(2*N1*N2-N1-N2)/( (N1+N2)^2 * (N1+N2-1));
p(2)=normcdf(V,h0V,sqrt(varV));


%Set all p to equal symmetry (two tailed to one tail deviation )
p=1-(abs(p-0.5)+0.5);

if(M>1)
    %TPM does not apply for Group Comparisons
    p(1)=[];
end


