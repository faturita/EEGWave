function [chain2,chain3,chain4,chain5,chain6]=multiresolution(a,tipo)

chain2=[];
chain3=[];
chain4=[];
chain5=[];
chain6=[];
len=length(a);
%if tipo == 2 %Freeman 45°
    for i=1:len
        if a(i)==0 
                c=0;
        elseif a(i)>=0 & a(i)<45
                c=1;
        elseif a(i)>=45 & a(i)<=90
                c=2;
        elseif a(i)<0 & a(i)>-45
                c=7;
        elseif a(i)<=-45 & a(i)>=-90
                c=6;
        end
        chain2=[chain2 c];
    end
%elseif tipo == 3 %PseudoFreeman 35°
    for i=1:len
        if a(i)==0 
            c=0;
        elseif a(i)>=0 & a(i)<35
            c=1;
        elseif a(i)>=35 & a(i)<70
            c=2;
        elseif a(i)>=70 & a(i)<=90
            c=3;
        elseif a(i)<0 & a(i)>-35
            c=4;
        elseif a(i)<=-35 & a(i)>-70
            c=5;
        elseif a(i)<=-70 & a(i)>=-90
            c=6;
        end
        chain3=[chain3 c];
    end
%elseif tipo == 4 %PseudoFreeman 25°
    for i=1:len
        if a(i)==0 
            c=0;
        elseif a(i)>=0 & a(i)<25
            c=1;
        elseif a(i)>=25 & a(i)<50
            c=2;
        elseif a(i)>=50 & a(i)<75
            c=3;
        elseif a(i)>=75 & a(i)<=90
            c=4;            
        elseif a(i)<0 & a(i)>-25
            c=5;
        elseif a(i)<=-25 & a(i)>-50
            c=6;
        elseif a(i)<=-50 & a(i)>-75
            c=7;
        elseif a(i)<=-75 & a(i)>=-90
            c=8;
        end
        chain4=[chain4 c];
    end
%elseif tipo == 5 %PseudoFreeman 15°
    for i=1:len
        if a(i)==0 
            c=0;
        elseif a(i)>=0 & a(i)<15
            c=0.5;
        elseif a(i)>=15 & a(i)<30
            c=1;
        elseif a(i)>=30 & a(i)<45
            c=1.5;
        elseif a(i)>=45 & a(i)<60
            c=2;            
        elseif a(i)>=60 & a(i)<75
            c=2.5;                        
        elseif a(i)>=75 & a(i)<=90
            c=3;            
        elseif a(i)<0 & a(i)>-15
            c=3.5;
        elseif a(i)<=-15 & a(i)>-30
            c=4;
        elseif a(i)<=-30 & a(i)>-45
            c=4.5;
        elseif a(i)<=-45 & a(i)>-60
            c=5;
        elseif a(i)<=-60 & a(i)>-75
            c=5.5;                        
        elseif a(i)<=-75 & a(i)>=-90
            c=6;       
        end
        chain5=[chain5 c];
    end    
%elseif tipo == 6 %binario
    for i=1:len
        if a(i)>=0
            c=1;
        else
            c=-1;
        end
        chain6=[chain6 c];
    end
    

%end
