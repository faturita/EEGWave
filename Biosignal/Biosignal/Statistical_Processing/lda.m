function [y,w]=lda(x,labels)
% 
% [y,w]=lda(x,labels)
% 
% 
% Two dimenstional linear discriminant analysis.
% 
% %Example 
% 
% m1=[3 10];
% s1=[1 5; 5 30];
% r1 = mvnrnd(m1,s1,1000);
% m2=[5 3];
% s2=s1;
% r2 = mvnrnd(m2,s2,1000);
% 
% r=[r1;r2];
% labels=[zeros(100,1);ones(100,1)];
% [y,w]=lda(r,labels);
% 
% subplot(211)
% plot(r1(:,1),r1(:,2),'r+')
% hold on;grid on
% plot(r2(:,1),r2(:,2),'o')
% 
% subplot(212)
% hist(y,100)
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

%Each row is an observation and each column a feature
labels=labels(:);
[N,M]=size(x);
tags=unique(labels);
C=length(tags);

if(C>2)
    error(['Labels have more than one category.'])
end

x1=x(labels==tags(1),:);
x2=x(labels==tags(2),:);
m1=mean(x1);
m2=mean(x2);

S1=cov(x1-repmat(m1,[length(x1) 1]));
S2=cov(x2-repmat(m2,[length(x2) 1]));
Sw=S1+S2;

w=(m1-m2)*inv(Sw);

y=x*w';



