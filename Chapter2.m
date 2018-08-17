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