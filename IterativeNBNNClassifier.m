function [DE, ACC, ERR, AUC, SC] = IterativeNBNNClassifier(F,channel,trainingRange,labelRange,testRange, adaptative,balancebags)

fprintf('Channel %d\n', channel);
fprintf('Building Test Matrix M for Channel %d:', channel);
[TM, TIX] = BuildDescriptorMatrix(F,channel,labelRange,testRange);
fprintf('%d\n', size(TM,2)); 

DE = NBNNFeatureExtractor(F,channel,trainingRange,labelRange,[1 2],balancebags); 

iterate=true;
while(iterate)
    fprintf('Bag Sizes %d vs %d \n', size(DE.C(1).IX,1),size(DE.C(2).IX,1)); 
    [ACC, ERR, AUC, SC] = NBNNClassifier(F,DE,channel,testRange,labelRange,false);
    P = SC.TN / (SC.TN+SC.FN);
    ACC = 1-ERR/size(testRange,2);

    if (adaptative)
        [reinf1, reinf2] = RetrieveMisleadingDescriptors(F,testRange,SC,DE,TIX);

        if ( ((size(reinf1,2)>0) || (size(reinf2,2)>0)) && (size(DE.C(1).IX,1) >15 && size(DE.C(2).IX,1) >15) )
            iterate=true;
            exclude{1}=reinf1;
            exclude{2}=reinf2;
            DE = NBNNIterativeFeatureExtractor(DE,[1 2],exclude);

            assert( size(DE.C(1).IX,1) > 0, 'No more descriptors to prune');
            assert( size(DE.C(2).IX,1) > 0, 'No more descriptors to prune');
        else
            fprintf('Nothing to update.');
            iterate=false;
        end
    else
        % Just one iteration. I wonder why matlab do not have do until.
        iterate = false;
    end

end

end
