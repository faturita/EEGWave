function [normal,factor]=normalizasd(signal)

media=mean(signal);
sd=std(signal);
max_signal=media+sd;
min_signal=media-sd;

[M,N]=size(signal);

factor=(2)./(max_signal-min_signal);
normal=(repmat(factor,M,1).*(signal-repmat(min_signal,M,1)))-1;

