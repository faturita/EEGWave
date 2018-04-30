function feature = MIDSFeatureSignal(signal,Ts)

sig = signal;

locs = 1:size(sig,2);

% Hacerlo hasta que no tenga mas cambios
for i=1:70

    [a,b,feature] = MIDSFeature(sig,Ts,locs);
    
    sig = feature;
    locs = a;
end
    
newsignal = linearfillmissingvalues(signal,a);

assert (size(newsignal,2) == size(signal,2), 'Error generating MIDS feature');

feature = newsignal;

end