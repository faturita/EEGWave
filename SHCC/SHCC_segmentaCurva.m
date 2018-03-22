function [x1,y1]=SHCC_segmentaCurva(x,y,seg)

lenx=length(x);
a=lenx/(seg+1);
x1=x(1:a:end);  
y1=y(1:a:end);



