T=[2	2	1	6	6	6	6	7	2	2	2	2	2	2	2	2	6	6	6	7	2	6	6	6	6	6	6	2	2	2	2	7	6	7	7	7	2	2	2	2]
N=[2	2	2	2	2	2	6	6	6	6	2	1	6	6	7	6	6	6	2	2	2	2	7	7	7	6	6	1	2	2	7	6	7	1	6	6	7	2	2	2]
P=[2	7	6	2	2	6	6	6	2	2	2	2	2	1	6	6	6	6	6	6	7	6	6	6	6	7	6	6	2	2	2	6	6	7	6	6	2	2	2	2]
[dist, D, aLongestString]=LCS(T,N);
% 
% figure
% hold on
% title 'template'
% plot(T)
% hold off
% figure
% hold on
% title 'nonP300'
% plot(N)
% hold off
% figure
% hold on
% title 'P300'
% plot(P)
% hold off

