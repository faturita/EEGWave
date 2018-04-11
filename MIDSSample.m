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

signal=signal(1:120);

sig = signal;

[a,b,feature] = MIDSFeature(sig,Ts);

subplot(3,1,1);
plot(sig);
subplot(3,1,2);
plot(a,sig(a));

%sig(b) = interp1(1:size(a,2),sig(a),b,'lineal')

subplot(3,1,3);
plot(sig)

[aa,b,feature2] = MIDSFeature(feature,Ts);

subplot(3,1,1);
plot(sig);
subplot(3,1,2);
plot(a,feature);

%sig(b) = interp1(1:size(a,2),sig(a),b,'lineal')

subplot(3,1,3);
plot(a(aa),feature2);
