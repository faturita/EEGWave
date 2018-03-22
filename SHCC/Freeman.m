function cc=Freeman(angulo)
cc=[]
for i=1:length(angulo)
    if angulo(i) > 0 & angulo(i) <= 45
        cc=[cc 1]
    elseif angulo(i) > 45 & angulo(i) <= 90
        cc=[cc 2]
    elseif angulo(i) < 0 & angulo(i) >= -45
        cc=[cc -1]
    elseif angulo(i) < -45 & angulo(i) >= -90
        cc=[cc -2]    
    end
end
