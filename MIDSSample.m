rng(756312);
indata = rand( 1, 7777 ); % generate random data points 
for i = 4000:7000 % generate change of data complexity 
indata( i ) = 4*indata( i - 1 )*( 1 - indata( i - 1 ) ); 
end 

load cuspamax;

Fs=1024;
Ts=1/Fs;

%indata=1*sin(1:64);

indata = cuspamax+indata(1:1024);

figure;plot(indata);

signal = indata;

signal=signal(1:20);
sig = signal;

locs = 1:size(sig,2);

for i=1:70

    [a,b,feature] = MIDSFeature(sig,Ts,locs);

    subplot(3,1,1);
    plot(signal);
    subplot(3,1,2);
    plot(a,signal(a));

    %sig(b) = interp1(1:size(a,2),sig(a),b,'lineal')

    subplot(3,1,3);
    plot(feature)
    
    sig = feature;
    locs = a;
end
    

% [aa,b,feature2] = MIDSFeature(feature,Ts,a);
% 
% subplot(3,1,1);
% plot(sig);
% subplot(3,1,2);
% plot(a,feature);
% 
% %sig(b) = interp1(1:size(a,2),sig(a),b,'lineal')
% 
% % x,y son los valores de la funcion y xi los que quiero interp
% %yi = interp1q(x,y,xi); 
% 
% 
% subplot(3,1,3);
% plot(aa,feature2);

%%
newsignal = linearfillmissingvalues(signal,a);

subplot(2,1,1);plot(a,signal(a));
subplot(2,1,2);plot(1:size(signal,2),newsignal);

