function [atrials,average]=wnsfmp(tmp,init,param,mode)
%
% [atrials,average]=wnsfmp(data,init,param,mode)
%
% Weighted Non-stationary Fixed Multi-Point SNR estimation (WNSFMP)
% Function for performing recursive averaging under non stationary conditions based on Silva (2009).
% This function is implement with persistent variables so that averaging over a large number of trials
% can be done by reading data from file and performing multiple calls to WNSFMP with the INIT variable set to
% 0 after the first call (all input parameters do not change uner init=1). Inputs to the function are:
%
% data    -(NxM) Data to be averaged. Where N is the lenght of a trial (epoch) and  M is
%           the total number of trials.
% init    -(1x1) Parameter to initialize the averaging in order to use the averaging for
%          long datasets in which the next set of trials have to be read from file.
% tm      -(Nx1) Time vector in seconds wrt stimulus onset.
% param   -(na) Structure containing the parameters of the procedure and the following fields:
%               frat - (1x1) Parameter for controling the segmentation of the noise sources.
%                            Note that 0<= frat <=1. With 0 yielding maximum segmentation and 1
%                            yielding minimum segmenation (1 == stationary condition).
%               Npts - (1x1) Number of point within a trial to estimate the noise variance (Npts <= tm).
%               blcks- (1x1) Minimum number of trials for which to estimate the noise source.
%                            Note that under frat=0, the number of independent noise sources estimated
%                            will be round(M/blcks). The value of blcks should be, in theory, the minimum
%                            duration for which you think the noise can be considered locally stationary.
%              st    - (1x1) Sample number from which to start estimating the signal power and applying the
%                            artifact rejection threshold in order to avoid stimulus artifact (0<st<=N).
%              nd    - (1x1) Sample number from which to stop estimating the signal power for SNR estimation.
%              art_th- (1x1) Artifact rejection threshold. Any trial whose absolute amplitude is higher
%                            than this threshold will be discarded.
% mode   -(Lx1) String with eht following options:
%          'ave'  -averages the data into a single average
%          'sub'  -averages the data into 2 "independent" averages and compute statistics between them
%
%
% Output arguments for the function are:
%
% atrials -(1x1) Total number of accepted trials (can be different from input due to artifact rejection and
%          if the function is used more than once with init=1 and multiple calls.
% average -(struct) Structure with the following data:
%           Under 'ave' mode
%           -----------------
%           sig   -(Nx1) Weighted averaged waveform using all trials
%           nsig  -(Nx1) Normal averaged waveform using all trials
%           w     -(1xatrials) Weight for each trial
%           wsnr  -(1xatrials) Estimated SNR under the weighted average condition.
%           ssnr  -(1xatrials) Estimated SNR under the normal (stationary) condition.
%           resW  -(1xatrials) Estimated weighted average residual noise power
%           resN  -(1xatrials) Estimated normal average residual noise power
%
%
%           Under 'sub' mode
%           -----------------
%           nsig1 -(Nx1) First normal subaverage
%           nsig2 -(Nx1) Second normal subaverage
%           w1    -(1xatrials1) Weight for each trial of subaverage1
%           w2    -(1xatrials2) Weight for each trial of subaverage2
%           wsig1 -(Nx1) First weigthed subaverage
%           wsig2 -(Nx1) Second weighted subaverage
%           wsnr1 -(1xatrials1) Estimated SNR under weighted condition for wsig1
%           wsnr2 -(1xatrials2) Estimated SNR under weighted condition for wsig2
%           ssnr1 -(1xatrials1) Estimated SNR under normal condition for wsig1
%           ssnr2 -(1xatrials2) Estimated SNR under normal condition for wsig2
%           resW1 -(1xatrials1) Estimated weighted average residual noise power for wsig1
%           resW2 -(1xatrials1) Estimated weighted average residual noise power for wsig2
%           resN1 -(1xatrials2) Estimated normal average residual noise power for nsig1
%           resN2 -(1xatrials2) Estimated normal average residual noise power for nsig2
%
%
% For further details see Silva,I, "Estimation of Postaverage SNR from Evoked Responses
% under Nonstationary Noise", 2009, 56(8)
%
%% Example
%%Generate sample data and define noise source paramerets
% tc = gauspuls('cutoff',50e3,0.6,[],-40);
% t = -tc : 1e-6 : tc;
% s = gauspuls(t',50e3,0.6);
% N=length(s);
% M=50;
% noise_sig=[10 20 1 10];
% L=length(noise_sig);
% %Define paramereters for the procedure
% param.frat=0.001;
% param.Npts=8;
% param.blcks=10;
% param.st=1;
% param.nd=N;
% param.art_th=inf;
% 
% %Generate data and call procedure
% for i=1:L
%     x=repmat(s,[1 M]) + randn(N,M).*noise_sig(i);
%     init=(i==1);
%     [atrials,average]=wnsfmp(x,init,param,'ave');
% end
% 
% subplot(311)
% plot(s,'g-');hold on;plot(average.sig,'b');plot(average.nsig,'r')
% legend('Signal','Weighted Average','Normal Average')
% title('Averaged Waveforms')
% subplot(312)
% plot(10*log10(average.resW),'b');hold on;plot(10*log10(average.resN),'r')
% ylabel('Residual Noise Level (dB)')
% xlabel('Trial Number')
% title('Estimated Residual Noise Power')
% legend('Weighted Average','Normal Average')
% subplot(313)
% noise_sig=repmat(noise_sig,[M 1]);
% plot(noise_sig(:))
% ylabel('Simulated Noise Power')
% xlabel('Trial Number')
% 
% %%%%END OF EXAMPLE %%%
% 
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




%Analyse the recorded data keep out of loop for efficiency....
persistent S Sraw abr nabr a ai M sigX NsigX trial_length st nd nabr1 nabr2 S1 S2 trials art_th

persistent wabr1 wabr2 sigX1 sigX2 NsigX1 NsigX2 old_tmp blcks Npts noise_segrat
%Initialize parameters for corresponding level
if(init)
    S=single([]); %segmented noise variance
    Sraw=single([]);%un-segmented noise variance
    S1=[];
    S2=[];
    a=single([]);   %max of each trial
    ai=[];          %rejected trials
    abr=0;
    nabr1=0;
    nabr2=0;
    wabr1=0;
    wabr2=0;
    nabr=0;
    M=0; %absolute number of trials
    trials=0;
    old_tmp=[];
    noise_segrat=param.frat;
    Npts=param.Npts;
    blcks=param.blcks;
    art_th=param.art_th; %artifact threshold in nano-volts
    st=param.st;
    nd=param.nd;
    
    
    sigX1=[];
    sigX2=[];
    NsigX1=[];
    sigX=[];
    
    NsigX2=[];
    NsigX=[];
    
end


%get rid of any dc component
[trial_length,total_trials]=size(tmp);
tmp=tmp-repmat(mean(tmp),[trial_length 1]);


% get rid of artifacts
amp=max(abs(tmp(st:end,:)));
if(isempty(a))
    a=amp;
else
    a=[a amp];
end
art_ind=find(amp>art_th);
tmp(:,art_ind)=[];
ai=[ai art_ind+M];
M=M+total_trials;
total_trials=total_trials - length(art_ind);

%Pre-append with any previous trials for other blocks/session
if(~isempty(old_tmp))
    tmp=[old_tmp tmp];
    total_trials=total_trials+length(old_tmp(1,:));
end
old_tmp=tmp;
Mid=round(total_trials/2); %Find the mid-point for the sub-averaging

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Estimate variance within blcks of trials
if(blcks==inf)
    blcks=total_trials;
end
%With Collapse of noise regions collapsing within blocks
[vns,tmp,total_trials]=fmp3(tmp,trial_length,total_trials,Npts,blcks,1,0,noise_segrat);

%store unused trial until nextime function is called
unused=length(old_tmp(1,:))-length(tmp(1,:));
old_tmp(:,1:end-unused)=[];

if(total_trials ==0)
    %all trials have been excluded due to artifact rejection level
    atrials=trials;
    ssnr=NaN;
    wsnr=NaN;
    NvarX=NaN;
    r=NaN;
    average=NaN;
    return
end

%Record # of accepted trials
trials=trials + total_trials;
atrials=trials;

[vns_raw,trash,trash]=fmp3(tmp,trial_length,total_trials,Npts,blcks,0,0,[]);
temp_vns=repmat(vns(:)',[blcks 1]);
temp_vns=temp_vns(:);
temp_vns_raw=repmat(vns_raw(:)',[blcks 1]);
S=[S; temp_vns];
Sraw=[Sraw; temp_vns_raw(:)];

%Collapsing noise estimates across blocks
if(length(unique(S))>1)
    [S]=noise_sgmt2(S,length(S),Npts*blcks,noise_segrat);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Perform recursive weighted averaging of response
[abr,w]=rw_average2(abr,tmp,total_trials,S);
%normal unweighted
[nabr,trash]=Nullrw_average(nabr,tmp,total_trials,S);

%Estimate SNR
[snr_curve,Nsnr_curve,ssnr,wsnr,sigX,NsigX,NS,sigN,NsigN]=snr(abr,nabr,S,st,nd,sigX,NsigX);

%Break block to estimate two sub-averages
S1=[S1; temp_vns(1:Mid)];
S2=[S2; temp_vns(Mid+1:end)];


if(strcmp(mode,'ave') )
    average.sig=abr;
    average.nsig=nabr;
    average.w=w;
    average.resW=sigN;
    average.resN=NsigN;
    average.ssnr=ssnr;
    average.wsnr=wsnr;
elseif(strcmp(mode,'sub') )
    %Normal recursive sub-averaging
    [nabr1,trash]=Nullrw_average(nabr1,tmp(:,1:Mid),Mid,S1);
    [nabr2,trash]=Nullrw_average(nabr2,tmp(:,Mid+1:end),total_trials-Mid,S2);
    
    %Weighted recursive sub-averaging
    [wabr1,w1]=rw_average2(wabr1,tmp(:,1:Mid),Mid,S1);
    [wabr2,w2]=rw_average2(wabr2,tmp(:,Mid+1:end),total_trials-Mid,S2);
    
    %Estimate SNRs
    [snr_crv1,Nsnr_crv1,ssnr1,wsnr1,sigX1,NsigX1,NS1,resW1,resN1]=snr(wabr1,nabr1,S1,st,nd,sigX1,NsigX1);
    [snr_crv2,Nsnr_crv2,ssnr2,wsnr2,sigX2,NsigX2,NS2,resW2,resN2]=snr(wabr2,nabr2,S2,st,nd,sigX2,NsigX2);
    
    
    average.nsig1=nabr1;
    average.nsig2=nabr2;
    average.w1=w1;
    average.w2=w2;
    average.ssnr1=ssnr1;
    average.ssnr2=ssnr2;
    average.wsig1=wabr1;
    average.wsig2=wabr2;
    average.wsnr2=ns_fmp2;
    average.wsnr1=ns_fmp1;
    average.resW1=resW1;
    average.resN1=resN1;
    average.resW2=resW2;
    average.resN2=resN2;
end





%%%%%% END OF MAIN %%%%%%%%



function [snr_curve,Nsnr_curve,ssnr,wsnr,sigX,NsigX,NS,sigN,NsigN]=snr(abr,nabr,S,st,nd,sigX,NsigX)

%Generating the indeces that indicate where respective noise sources end
NS=length(S);
S_ind=find(diff(S) ~= 0);
if(isempty(S_ind) || S_ind(end)~= NS)
    S_ind(end+1)= NS;
end

%Estimate residual background noise
sigN=S(:)';
sigN=1./cumsum(1./sigN(:)); %residual noise from weighted average
NsigN=ns_snrestm5(0,S(S_ind),S_ind); %residual noise from normal average

%Estimate Signal and Noise Variance

%Weighted average
sigX(end+1)=var(abr(st:nd));%delay and window to avoid stimulus artifact
snr_curve=sigX(end)./sigN;
%Normal average
NsigX(end+1)=var(nabr(st:nd));%delay and window to avoid stimulus artifact
Nsnr_curve=NsigX(end)./NsigN;

ssnr=max(Nsnr_curve(end));
wsnr=max(snr_curve(end));

if(isempty(ssnr))
    ssnr=NaN; %in case not enough trials have not been collected yet
    wsnr=NaN;
end




function [ave,w]=rw_average2(ave_old,new_data,M,S)

nS=length(S);
n_old=nS-M;

%estimate weights for weighted averaging recusively
W=1./S(:);
if(nS>M)
    alpha_old=1./sum(W(1:n_old));
else
    alpha_old=inf;
end
alpha=1./sum(W);
w=alpha.*W;

ave= (alpha/alpha_old)*ave_old + new_data*w(n_old+1:end);


function [ave,w]=Nullrw_average(ave_old,new_data,M,S)

nS=length(S);
n_old=nS-M;

%estimate weights for weighted averaging recusively
W=1./S;
W=W.*0 + 1; %normal averaging, used for debuging...
%display('***using normal averaging')
w_ave0=new_data*W(n_old+1:end);

alpha_old=sum(W(1:n_old));
alpha=1./sum(W);
ave=alpha.*( alpha_old.*ave_old + w_ave0);
w=W(:)./sum(W(:));





function [vns]=noise_sgmt2(vns,Mend,V,noise_segrat)

%Segment noise sections dynamically according to F-test of variance
ind_unique=find([0;diff(vns)] ~= 0)-1;
if(isempty(ind_unique))
    return
end
if(noise_segrat==0 || noise_segrat==1)
    %extreme cases
    if(noise_segrat==0)
        %no merging possible
        return
    else
        %merge all trials
        vns=repmat(mean(vns),[1 Mend]);
        return
    end
end

ind_width=[ind_unique(1);diff(ind_unique)];
if(ind_unique(end) ~= Mend)
    ind_unique(end+1)=Mend;
    ind_width(end+1)= Mend-ind_unique(end-1);
end

Mend=length(ind_unique);
leak=inf;

if(Mend>1)
    %Collapse noise regions by F-test of variance
    for m=[2:Mend]
        v1=ind_width(m-1)*V;
        v2=ind_width(m)*V;
        d1=min([v1 leak]); %add a leak factor to forget far values
        d2=min([v2 leak]); %add a leak factor to forget far values
        F05=finv(noise_segrat,d1,d2);
        F95=finv(1-noise_segrat,d1,d2);
        F=vns(ind_unique(m-1))/vns(ind_unique(m));
        
        %Hypothesis Test
        if(F05 <= F & F <= F95)
            %variances are equal, collapse blocks and
            %generate better estimate of noise variance
            st=ind_unique(m-1)-ind_width(m-1)+1;
            nd=ind_unique(m);
            val=(v1*vns(ind_unique(m-1))+ v2*vns(ind_unique(m)))/(v1+v2);
            vns(st:nd)=vns(st:nd).*0 + val;
            
            %Update current index vector # of samples due to merger
            ind_width(m)=ind_width(m-1)+ind_width(m);
            %             hold on
            %             plot(vns,'-o')
            %             pause
        end
    end
    
end




function [vns,data,M]=fmp3(data,N,M,Npts,blcks,collapse,draw,noise_segrat)
% [vns]=fmp(data,Npts,blcks)
%estimate variance across muliple trials over fixed
%time points

stp=ceil(N/Npts);
tmp_Npts=ceil(N/stp);

if(tmp_Npts ~= Npts)
    Npts=tmp_Npts;
    warning(['Using :',num2str(Npts),' pts per block.'])
end

Mend=floor(M/blcks);
V=Npts*blcks;

if(Mend*blcks < M)
    data(:,Mend*blcks+1:end)=[];
    M=Mend*blcks;
end

if(M >= blcks)
    ns=data(1:stp:end,:);
    Nend=Npts*blcks*Mend;
    ns=reshape(ns(1:Nend),[Npts blcks Mend]);
    if(Npts>1)
        if(blcks>1)
            Mns=mean(ns,2);
            MNS=repmat(Mns,[1 blcks 1]);
            ns=ns-MNS; %subtract mean from samples
            vns=squeeze(mean(var(ns,[],2))); %estimate across a block
        else
            ns=squeeze(ns)-repmat(mean(squeeze(ns)),[Npts 1]);
            vns=squeeze(var(ns))'; %estimate within a block used for simulation only
        end
    else
        Mns=mean(ns,2);
        MNS=repmat(Mns,[1 blcks 1]);
        ns=ns-MNS; %subtract mean from samples
        vns=squeeze(var(ns,[],2)); %estimate across a block
    end
    if(collapse)
        if(draw)
            vns_ind=vns;
            [vns]=noise_sgmt2(vns,Mend,V,noise_segrat);
            plot(vns_ind,'-or'); hold on
            plot(vns)
        else
            [vns]=noise_sgmt2(vns,Mend,V,noise_segrat);
        end
        
    end %of collapse
else
    vns=[];
    fprintf(['\t Not enougth blocks to predic noise...\n'])
end %of number of trials condition & running average loop




function pwr=ns_snrestm5(sigS,sigN,n)
% 
% pwr=ns_snrestm4(sigS,sigN,n)
% 
% pwr - vector estimated SNR (or residual noise if sigS =0)
% sigS - power of final average or estimated signal power
% sigN - vector of estimated variances.Noise of N(k) goes from
%         from n(k-1)+1 to n(k).
% n    - vector of of time indeces. n(k) is where noise source N(k) ends
% (alternatively, n(k-1)+1 is where source N(k) begins).

n=n(:);
sigN=sigN(:);
K=length(sigN);
pwr=zeros(n(end),1);
N=[n(1);diff(n)];
pwr(1:n(1))=sigS + sigN(1)./[1:n(1)];


for k=2:K,
    
    xtra=N(1:k-1)'*sigN(1:k-1); 
    ind=n(k-1)+[1:N(k)];
    den=ind.^2;
    pwr(n(k-1)+1:n(k))= sigS + xtra./den + ([1:N(k)].*sigN(k))./den ;
    
end

