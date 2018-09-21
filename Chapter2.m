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



%%
% Check the influence of the scale of the image on the descriptors
%[eegimg, DOTS, zerolevel] = eegimage(8,output,imagescale*8,timescale*2, false,minimagesize);


[eegimg, DOTS, zerolevel, height] = eegimageinvariant(8,output,imagescale,timescale, false,minimagesize);
figure;imshow(eegimg);
  

%%
output = extract(data.X, ...
    (ceil(time1/downsize)), ...
    floor(Fs/downsize)*windowsize);

[eegimg, DOTS, zerolevel] = eegimage(8,output,imagescale,timescale, false,minimagesize);
figure;imshow(eegimg);
imwrite(eegimg,'plottingsample.png');
fdsfdsfsd


%% 
[hdr, record] = edfread(sprintf('%s/%s/%s',getdatasetpath(),'KComplexes','excerpt1.edf'));
Fs=200;
figure;plot(record(3,round(50.4113*200):round(50.4113*200+0.6544*200)))




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


%%
% Parameters ==============
epochRange = 1:30;
channelRange=1:14;
labelRange = [ones(1,15)+1 ones(1,15)];
imagescale=1;siftscale=1;siftdescriptordensity=1;
% =========================

output = cell(1,30);

for epoch=epochRange     % subject

    label=labelRange(epoch);   % experiment

    if (label == 1)
        filename='EyesOpen';
    else
        filename='EyesClosed';
    end
    
    if (epoch>=16)
        subject = epoch-15;
    else
        subject = epoch;
    end
    
    directory = sprintf('Rodrigo%s',filesep);
    file = sprintf('eeg_%s_%i.dat',filename,subject);
    
    fprintf('%s%s%s\n', directory, filesep, file );
    
    output{epoch} = loadepoceegraw(directory,file,1); 

end


outp = output{15}(:,7:8);

[eegimg, DOTS, zerolevel] = eegimage(1,outp,imagescale,timescale*2, false,minimagesize,false,false);
figure;imshow(eegimg);
print('samplepoints','-depsc');

[eegimg, DOTS, zerolevel] = eegimage(1,outp,imagescale,timescale*2, false,minimagesize,false,true);
figure;imshow(eegimg);
print('bresenham','-depsc');

[eegimg, DOTS, zerolevel] = eegimage(1,outp,imagescale,timescale*2*4, false,minimagesize,false,true);
figure;imshow(eegimg);
print('upscaled','-depsc');

outp2(:,1) = resample(outp(:,1),1:size(outp,1),4,'linear');
outp2(:,2) = resample(outp(:,2),1:size(outp,1),4,'linear');

[eegimg, DOTS, zerolevel] = eegimage(1,outp2,imagescale,timescale*2, false,minimagesize,false,true);
figure;imshow(eegimg);
print('upsample','-depsc');

