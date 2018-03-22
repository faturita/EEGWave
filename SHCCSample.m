indata = rand( 1, 7777 ); % generate random data points 
for i = 4000:7000 % generate change of data complexity 
indata( i ) = 4*indata( i - 1 )*( 1 - indata( i - 1 ) ); 
end 

indata=1*sin(1:64);

figure;plot(indata);

s=chainCode(1:64,indata,1,10,0,0)

figure;plot(s.amplitudNorm);

figure;plot(s.chainSHCC)



