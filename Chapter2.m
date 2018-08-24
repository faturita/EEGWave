% Chapter 2 - Thesis
% Plotting

clear all
close all

load(sprintf('./signals/p300-subject-%02d.mat', 21));
data = DrugSignal(data,10);

downsize=1;
windowsize=1;

time1=data.flash(4,1)/Fs;
time2=data.flash(4,1)/Fs+windowsize*5;


    
output = extract(data.X, ...
    (ceil(time1/downsize)), ...
    floor(Fs/downsize)*windowsize);
    
imagescale=1;
timescale=1;

minimagesize=1;

%%
output = zeros(size(output));

output(125,8) = 50;
 
[eegimg, DOTS, zerolevel] = eegimage(8,output,imagescale,timescale, false,minimagesize);
figure;imshow(eegimg);
pause


%%
% Check the influence of the scale of the image on the descriptors
%[eegimg, DOTS, zerolevel] = eegimage(8,output,imagescale*8,timescale*2, false,minimagesize);


[eegimg, DOTS, zerolevel, height] = eegimageinvariant(8,output,imagescale,timescale, false,minimagesize);
figure;imshow(eegimg);
pause  

%%
output = extract(data.X, ...
    (ceil(time1/downsize)), ...
    floor(Fs/downsize)*windowsize);

[eegimg, DOTS, zerolevel] = eegimage(8,output,imagescale,timescale, false,minimagesize);
figure;imshow(eegimg);
pause




%% 
[hdr, record] = edfread(sprintf('%s/%s/%s',getdatasetpath(),'KComplexes','excerpt1.edf'));
Fs=200;
plot(record(3,round(50.4113*200):round(50.4113*200+0.6544*200)))

output=record(3,round(50.4113*200):round(50.4113*200+0.6544*200));
output=output';
[eegimg, DOTS, zerolevel] = eegimage(1,output,imagescale,timescale*2, false,minimagesize);

eegimg(floor(size(eegimg,1)/2),floor(size(eegimg,2)/2)) = 0;

for i=-10:10
    eegimg(floor(size(eegimg,1)/2)+i,floor(size(eegimg,2)/2)+i) = 0;
    eegimg(floor(size(eegimg,1)/2)+i,floor(size(eegimg,2)/2)-i) = 0;
end


figure;imshow(eegimg);


% signal = record(3,:);
% sg = bandpasseeg(signal', 1:1, Fs);
% 
% amplification = 12;
% sg = zscore(sg) * amplification;
% 
% signal = sg;

