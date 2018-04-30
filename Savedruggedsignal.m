clear all
close all
subject=21;
delaylag=0;
amplitude=1.2;
load(sprintf('./signals/p300-subject-%02d.mat', subject));
data = DrugSignal(data,amplitude,delaylag);

save(sprintf('./signals/p300-subject-drug-21.mat'));


plot(data.X)

