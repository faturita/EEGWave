function [wns_fmp,ns_fmp,r,atrials,average]=nsfmp(tmp,init,tm,param,mode)


[wns_fmp,ns_fmp,r,atrials,average]=nsfmp(data,init,tm,param,mode)

Function for performing recursive averaging under non stationary conditions based on Silva (2009). 
Inputs to the function are:

data    -(NxM) Data to be averaged. Where N is the lenght of a trial (epoch) and  M is 
          the total number of trials. 
init    -(1x1) Parameter to initialize the averaging in order to use the averaging for
         long datasets in which the next set of trials have to be read from file.
tm      -(Nx1) Time vector in seconds wrt stimulus onset.
param   -(na) Structure containing the parameters of the procedure and the following fields:
              frat - (1x1) Parameter for controling the segmentation of the noise sources.
                           Note that 0<= frat <=1. With 0 yielding maximum segmentation and 1
                           yielding minimum segmenation (1 == stationary condition).
              Npts - (1x1) Number of point within a trial to estimate the noise variance (Npts <= tm).
              blcks- (1x1) Minimum number of trials for which to estimate the noise source.
                           Note that under frat=0, the number of independent noise sources estimated
                           will be round(M/blcks). The value of blcks should be, in theory, the minimum
                           duration for which you think the noise can be considered locally stationary.
             Fs    - (1x1) Sampling frequency in Hz.
             art_th- (1x1) Artifact rejection threshold. Any trial whose absolute amplitude is higher
                           than this threshold will be discarded.
mode   -(Lx1) String with eht following options:
         'ave'  -averages the data into a single average
         'sub'  -averages the data into 2 "independent" averages and compute statistics between them
         
    

%Scrip to test if clock & sync are working properly
%Both inputs to the soundcard should be connected to headphone buffer
%Trigger signal -> Left channel (1)
%Data signal -> right channel (2)
%Attenuation is expected of recording if HB7 is not set to 0.
% param:
%         art_th   artifact rejection threshold
%         snr_th   snr threshold to quit
%         cor_th   correlation threshold to quit
%         num_trl  minimum number of trials to estimate signal variance
%         frat     frat level to segment noise
%         mode     mode options are: abrave, oaeave, sim, exp, and chk


noise_segrat=param.frat;
Npts=param.Npts;
blcks=param.blcks;
art_th=param.art_th; %artifact threshold in nano-volts
fc=param.Fs;

%Analyse the recorded data keep out of loop for efficiency....
persistent S Sraw abr nabr a ai M sigX NsigX trial_length st nd nabr1 nabr2 S1 S2 trials acoust_noise

persistent wabr1 wabr2 sigX1 sigX2 NsigX1 NsigX2 C Ccount old_tmp
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
    C=[];
    Ccount=0;
    M=0; %absolute number of trials
    trials=0;
    old_tmp=[];
    
    sigX1=param.sigpow;
    sigX2=param.sigpow;
    NsigX1=param.sigpow;
    NsigX2=param.sigpow;
    NsigX=param.sigpow;
    sigX=param.sigpow;
    trial_length=length(tm);
end


%get rid of any dc component
[N,total_trials]=size(tmp);
tmp=tmp-repmat(mean(tmp),[N 1]);
    

% get rid of artifacts
amp=max(abs(tmp(st:end,:)));
if(isempty(a))
    a=amp;
else
    a=[a amp];
end
art_ind=find(amp>art_th);
tmp(:,art_ind)=[];
ai=[ai art_ind+(M/prs)];
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
    ns_fmp=NaN;
    wns_fmp=NaN;
    NvarX=NaN;
    r=NaN;
    data=NaN;
    return
end

%Record # of accepted trials
trials=trials + total_trials*prs;
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
[snr_curve,Nsnr_curve,ns_fmp,wns_fmp,sigX,NsigX,NS,sigN,NsigN]=snr(abr,nabr,S,prs,sigX,NsigX,st,nd);

%Break block to estimate two sub-averages
S1=[S1; temp_vns(1:Mid)];
S2=[S2; temp_vns(Mid+1:end)];


if(strcmp(mode,'ave') )
    
    %In average mode there is only one signal available and that is either
    %OAE or ABR. In either case, the signal is stored under the ABR
    %variable name in this function workspace
    
    %Normal recursive sub-averaging
    [nabr1,trash]=Nullrw_average(nabr1,tmp(:,1:Mid),Mid,S1);
    [nabr2,trash]=Nullrw_average(nabr2,tmp(:,Mid+1:end),total_trials-Mid,S2);
    
    
    %Weighted recursive sub-averaging
    [wabr1,w1]=rw_average2(wabr1,tmp(:,1:Mid),Mid,S1);
    [wabr2,w2]=rw_average2(wabr2,tmp(:,Mid+1:end),total_trials-Mid,S2);
    
    %Estimate SNRs
    [snr_crv1,Nsnr_crv1,ns_fmp1,wns_fmp1,sigX1,NsigX1,NS1,resW1,resN1]=snr(wabr1,nabr1,S1,prs,sigX1,NsigX1,st,nd);
    [snr_crv2,Nsnr_crv2,ns_fmp2,wns_fmp2,sigX2,NsigX2,NS2,resW2,resN2]=snr(wabr2,nabr2,S2,prs,sigX2,NsigX2,st,nd);
    
    data.sig=abr;
    data.nsig=nabr;
    data.w=w;
    data.C=[];
    data.ns_fmp=ns_fmp;
    data.wns_fmp=wns_fmp;
    data.nsig1=nabr1;
    data.nsig2=nabr2;
    data.w1=w1;
    data.w2=w2;
    data.wsig1=wabr1;
    data.wsig2=wabr2;
    data.tm=tm;
    data.wns_fmp2=ns_fmp2;
    data.wns_fmp1=ns_fmp1;
    data.st=st;
    data.nd=nd;
    data.resW=sigN;
    data.resN=NsigN;
    data.resW1=resW1;
    data.resN1=resN1;
    data.resW2=resW2;
    data.resN2=resN2;
    r=corrcoef(nabr1,nabr2);
    r=r(2);
else
    %Estimate two independent sub-averages and their x-correlation
    [nabr1,trash]=rw_average2(abr,tmp(:,1:Mid),Mid,S1);
    [nabr2,trash]=rw_average2(abr,tmp(:,Mid+1:end),total_trials-Mid,S2);
    r=corrcoef(nabr1,nabr2);
    r=r(2);
    data=sigX(end);
end





%%%%%% END OF MAIN %%%%%%%%



function [snr_curve,Nsnr_curve,ns_fmp,wns_fmp,sigX,NsigX,NS,sigN,NsigN]=snr(abr,nabr,S,prs,sigX,NsigX,st,nd)

%Generating the indeces that indicate where respective noise sources end
NS=length(S);
S_ind=find(diff(S) ~= 0);
if(isempty(S_ind) || S_ind(end)~= NS)
    S_ind(end+1)= NS;
end

%Estimat residual background noise
sigN=repmat(S(:)',[1 prs]);
sigN=1./cumsum(1./sigN(:)); %residual noise from weighted average
NsigN=ns_snrestm5(0,S(S_ind),S_ind.*prs); %residual noise from normal average

%Estimate Signal and Noise Variance

%Weighted average
%sigX(end+1)=min(var(abr(st:nd)-mean(abr(st:nd))),sigX(end));%delay and window to avoid stimulus artifact
sigX(end+1)=var(abr(st:nd));%delay and window to avoid stimulus artifact
snr_curve=sigX(end)./sigN;
%Normal average
%NsigX(end+1)=min(var(nabr(st:nd)-mean(nabr(st:nd))),NsigX(end));%delay and window to avoid stimulus artifact
NsigX(end+1)=var(nabr(st:nd));%delay and window to avoid stimulus artifact
Nsnr_curve=NsigX(end)./NsigN;

ns_fmp=max(Nsnr_curve(end));
wns_fmp=max(snr_curve(end));

if(isempty(ns_fmp))
    ns_fmp=NaN; %in case not enough trials have not been collected yet
    wns_fmp=NaN;
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
