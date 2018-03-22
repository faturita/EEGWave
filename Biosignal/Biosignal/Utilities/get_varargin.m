function [in_params_err]=get_varargin(varargin)
%
%[in_params_err]=get_varargin(in_params,in_params_default,varargin,in_params_catch);
%
%Function to help populate its calling function (CF) with
%variable number of input arguments, default values, and (optional) catching
%conditions. Required variables need to be passed first and in specific order
%according to function signature. All other variables can be passed in
%order with empty brackets for unused variables, or in random order in
%pairs with a '&' prefix before the variable name as string followed by the
%variable value (see example below).
%
%Parameters are:
%in_params             -Nx1 cell array of strings of the input arguments in the CF
%in_params_default     -Nx1 cell array of input argument's defaut values
%in_params_catch       -(optional) Nx1 cell array of catching conditions in for
%                       which the variable in the CF must statisfy .in_params_catch is not
%                       required, but if passed, must be same size as others, enter []
%                       for an input in which you dont care to check
%                       condition (see example function below)
%
%in_params_err        -Returns error message if in_params_catch exist and
%                      condition is broken, otherwise returns always empty
%
%
%%Example1
%%Here is a simple tone generating function with 6 input arguments (only
%%first two required, rest is optional and set to defaul values). For
%%example using all syntax below are equivalent for the function in the
%%example:
%tone(1000,1,[],[],'rectwin')
%tone(1000,1,'&win','rectwin')
%tone(1000,1,[],0,'&win','rectwin') %fase default is 0
%tone(1000,1,'&fase',0,'&win','rectwin')
%
%
%%Example 2- Errors
%tone(1000,1) %the following works because dur>0
%tone(1000,-1) %will issue an error because dur <0
%
%
% %%%%%Begin Tone%%%%%
% function [x,tm]=tone(varargin)
% %[x,tm]=tone(f,dur,Fs,fase,win,show)
% %
% %Function signature, default values, catch input trait, and error to throw
% in_params={'f,dur,Fs,fase,win,show'};
% in_params_default={varargin{1},varargin{2},48000,0,'hanning',[]};
% in_params_catch={'f<0','dur<0',[],[],'~ischar(win)',[]};
% 
% %Call get_varargin which populates the function, catches, and throws errors
% %based on inputs and conditions in in_params_catch
% in_params_err=get_varargin(in_params,in_params_default,varargin,in_params_catch);
% if(~isempty(in_params_err))
%     %Incorrect syntax has occured
%     str=['Input Error Using: \n [x,t]=tone(f,dur,Fs,fase,win,show)\n'];
%     error('tone:InputError',[str,'\n',in_params_err])
% end
% 
% tm=0:1/Fs:dur;
% x=sin(2*pi*f*tm'+(pi*fase/180));
% x=x.*window(win,length(tm));
% 
% if(~isempty(show))
%     plot(tm,x,show)
%     grid on
% end
%
% %%%%End Tone%%%%%
%
%
%
%Written by Ikaro Silva 08/2008

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


in_params=textscan(varargin{1}{:},'%s','delimiter',',');
in_params=in_params{:};
in_params_default=varargin{2};
inputs=varargin{3};
N_inputs=length(inputs);
N_params=length(in_params);
in_params_err=[];

if(nargin>3)
    in_params_catch=varargin{4};
else
    in_params_catch=cell(N_params,1);
end

%Check for parameters out of order
id=[];
for j=1:N_inputs
    if(ischar(inputs{j}))
        ind=strfind(inputs{j},'&');
        if(~isempty(ind))
            tmp=inputs{j};
            in_name=tmp(ind+1:end);
            id2=find(strcmp(in_name,in_params)==1);
            id(end+1)=j+1;
            in_params_default{id2}=inputs{id(end)};
            inputs{j}=[];
        end
    end
end
if(~isempty(id))
    inputs{id}=[];
end

%Populate the Parameters according to what is passed to the function
for j=[1:N_params]
    if(N_inputs >= j)
        if(~isempty(inputs{j}))
            in_params_default{j}=inputs{j};
        end
    end
    assignin('caller',in_params{j},in_params_default{j});
    if(~isempty(in_params_catch{j}))
        eval([in_params{j},'=in_params_default{j};'])
        if(eval(in_params_catch{j}))
            str=['Argument ',in_params{j},' is ',in_params_catch{j}];
            in_params_err=str;
        end
    end

end

if(nargout==1)
    varargout(1)={in_params_err};
end

