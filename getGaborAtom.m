function atom = getGaborAtom(N,scale,timeShift,frequency,phase)
%This function obtains a Gabor atom of given parameters
%N- Length of the signal
%scale- must be in number of samples
%timeShift - must be in number of samples
%frequency - its normalized frequency from 0 to 0.5   f/fs;
%Phase - a value from 0 to 2 pi
%This version uses the number of samples but seconds can also be used.

atom =zeros(N,1);
for n=1:N
    atom(n,1) = (1/sqrt(scale))*exp(-pi*(n-timeShift)^2/scale^2) * cos(2*pi*frequency*    (n-timeShift)/N+phase);
end
atom = (1/norm(atom)) .* atom;   %Normalization
end

function [dictionary parameters]=constructDictionaryGabor()
%Construct a Gabor dictionary 
%parameters are scale timeshift and frequency

N=256;  %Size of the atom
scales = [2^1 2^2 2^3 2^4];  %More scales can be added
freqs  = [0 .001 .002 .05 .1 .2 .3 .4 .5];  % f/fs normalized frequency. More freqs can be added
timeShifts = [0 64 128];  %More time shifts can be added
phase =0; %More phase values can be added, here I'm fixinf phase to 0


dictionary = zeros(N,length(scales)*length(freqs)*length(timeShifts)*length(phase));
parameters = zeros(3,length(scales)*length(freqs)*length(timeShifts)*length(phase);
contador = 1;

for t=1:length(timeShifts)
    for f=1:length(freqs)
        for s=1:length(scales)
            dictionary(:,contador) = getGaborAtom(N,scales(s),timeShifts(t),freqs(f),phase);
            parameters(:,contador) = [scales(s) timeShifts(t) freqs(f)];
            contador = contador+1;
        end
    end
end
end