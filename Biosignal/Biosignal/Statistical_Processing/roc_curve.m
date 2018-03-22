function roc_area=roc_curve(data,varargin)
%
% roc_area=roc_curve(data,show)
%
% Plots the ROC curve and outputs the estimate ROC area.
% Parameters are:
%
% data        -(NxM) matrix.First column is the values under the NULL Hypothesis.
%              Aditional columns corresponds to values under different Hypothesis. All of
%              which are compared to the null Hypothesis.
%
% show        -(1xM-1) Character array for which to plot the ROC Curve. If
%               empty no plot is done.
%
% roc_area    -(M-1)x1 vector of the ROC area under different hypotheses
%
% %Example:
% N=1000;
% data=[randn(N,1) randn(N,1) 0.5+randn(N,1) 2+randn(N,1)];
% roc_curve(data,,['brg'])
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


[N,M]=size(data);
show=[];
if(nargin>1)
    if(~isempty(varargin{1}))
        show=varargin{1};
    end
end

%Generate ROC Curve
for i=2:M

    temp=[data(:,1) data(:,i)];
    alpha=sum(~isnan(temp(:,1)));
    beta=sum(~isnan(temp(:,2)));
    T=2*length(temp(:,1));
    fa=0;
    mh=0;
    roc=[];
    roc(1,1:2)=[fa mh];
    for j=1:T
        [val,ind_pt]=max(temp);
        if(val(1) >= val(2) || ( isnan(val(2))*~isnan(val(1)) ) )
            %false alarm case
            fa=fa+1;
            roc(end+1,:)=[fa/alpha mh/beta];
            temp(ind_pt(1),1)=NaN;
        elseif(val(1) < val(2) || ( isnan(val(1))*~isnan(val(2)) ) )
            %power, detection case
            mh=mh+1;
            roc(end+1,:)=[fa/alpha mh/beta];
            temp(ind_pt(2),2)=NaN;
        else
            %Count as both and move on
        end
    end
    if(~isempty(show))
        plot(roc(:,1),roc(:,2),show(i-1))
        hold on;grid on
        xlabel('False Alarm (Specificity)')
        ylabel('Hits (Sensitivity)')
    end
    roc_area(i-1)=sum([diff(roc(:,1)).*mean([roc(1:end-1,2) roc(2:end,2)],2)]);
end



