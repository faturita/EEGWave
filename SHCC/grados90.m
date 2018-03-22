function cc=grados90(angulo)
cc=[];
for i=1:length(angulo)
    if angulo(i) == 0 
        cc=[cc 0];
    elseif angulo(i) > 0 
        cc=[cc 1];
    elseif angulo(i) < 0
        cc=[cc 2];    
    end
end