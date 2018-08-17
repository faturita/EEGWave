indata = rand( 1, 7777 ); % generate random data points 
for i = 4000:7000 % generate change of data complexity 
indata( i ) = 4*indata( i - 1 )*( 1 - indata( i - 1 ) ); 
end 
delay = 1; % delay 1 between points in ordinal patterns (successive points) 
order = 3; % order 3 of ordinal patterns (4-points ordinal patterns) 
windowSize = 512; % 512 ordinal patterns in one sliding window 
outdata = PE( indata, delay, order, windowSize ); 
figure; 
ax1 = subplot( 2, 1, 1 ); plot( indata, 'k', 'LineWidth', 0.2 ); 
grid on; title( 'Original time series' ); 
ax2 = subplot( 2, 1, 2 ); 
plot( length(indata) - length(outdata)+1:length(indata), outdata, 'k', 'LineWidth', 0.2 ); 
%plot(  outdata, 'k', 'LineWidth', 0.2 ); 

grid on; title( 'Values of permutation entropy' ); 
linkaxes( [ ax1, ax2 ], 'x' );
k = size(indata,2) - (order+1-1) * delay;
