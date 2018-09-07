% Testing delay lag
d=[];

for i=1:100
d=[d randi(floor(256*1*0.4),1,1)-floor(256*1*0.4)];
end

plot(d);


