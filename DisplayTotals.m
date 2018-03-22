function totals = DisplayTotals(subjectRange,globalaccij,globalsigmaaccij,globalauc,globalspeller,channels)

informedinpaper =   [  0.845  
    0.863    
    0.872    
    0.859    
    0.862    
    0.886    
    0.886    
    0.923
    0.9
    0.9
    0.9
    0.9
    0.9
    0.9
    0.9
    0.9
    0.9
    0.9
    0.9
    0.9
    0.9
    0.9
    0.9
    0.9
    0.9
    0.9];

totals = [];
fid = fopen('experiment.log','a');
{'Subject','mokuhyou','Cz','Avg','Best Channel','Value','Stdv'}
for subject=subjectRange
    [ChAcc,ChNum] = max(globalspeller(subject,:));
    Stdv = globalsigmaaccij(subject,ChNum);
    
    CMean = mean(globalaccij(subject,:));
    
    % Classification rate @?Cz (channel 2)
    Cz = globalaccij(subject,2);
    
    totals = [totals ;subject informedinpaper(subject) [ Cz CMean ChNum ChAcc  Stdv]];

    fprintf(fid,'%d     ', subject);
    fprintf(fid,'& %s', channels{ChNum});
    %fprintf(fid,'& %6.4f $\\pm$ %4.4f \\\\\n', [ChAcc Stdv]);
    fprintf(fid,'& %3.0f $\\pm$ %3.0f \\\\\n', [informedinpaper(subject)*100 ChAcc*100]);
end
totals
fclose(fid);

end
