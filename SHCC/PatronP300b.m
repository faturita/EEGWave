function [indPico]=PatronP300b(signal)

    
    [minVolt,indMinVoltD]=min(signal.amplitudSeg(signal.indMaxVolt:end));    
    indMinVoltD=signal.indMaxVolt+indMinVoltD-1        
    
    %subchain=signal.chain6(1:indMinVoltD)
    subchain=signal.chain6(1:end)
    i=indMinVoltD-1
    countNeg=0
    while subchain(i)==-1
        countNeg=countNeg+1
        i=i-1
    end
    j=1
    countPos=zeros(1,10)
    while i>=1
        while i>=1 & subchain(i)==1 
            countPos(j)=countPos(j)+1
            i=i-1
            b=1
        end
        if b==1
            b=0
            index(j)=i+1
            j=j+1            
            
        end
        i=i-1
    end
    
    b=1
    ini=1
    while b==1
        [v,ind]=min(countNeg-countPos(ini:j-1))
        ind=ind+ini-1
        if signal.amplitudSeg(index(ind)) > 0
            ini=ind+1
        else
            indMinVoltA=index(ind)
            indPico=indMinVoltA:indMinVoltD
            b=0
        end
    end
        
    subplot(3,1,3);
    hold on
    plot(signal.tiempoSeg,signal.amplitudSeg);
    plot(signal.tiempoSeg(indMinVoltA),signal.amplitudSeg(indMinVoltA),'*r')
    plot(signal.tiempoSeg(indMinVoltD),signal.amplitudSeg(indMinVoltD),'*r')
    plot(signal.tiempoSeg(indPico),signal.amplitudSeg(indPico),'+k');
    hold off
