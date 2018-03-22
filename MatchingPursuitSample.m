load cuspamax;
mpdict = wmpdictionary(length(cuspamax),'LstCpt',...
   {{'wpsym4',2},'dct'});

%mpdict = ones(1024,2048);

%mpdict(:,1) = cuspamax;rand(1,1024);

[yfit,R,COEFF,IOPT,QUAL] = wmpalg('BMP',cuspamax,mpdict(:,1:2048));
plot(cuspamax,'k'); hold on;
plot(yfit,'linewidth',2); legend('Original Signal',...
    'Matching Pursuit');


sum(R)

[yfit,r,coeff,iopt,qual] = wmpalg('OMP',cuspamax,mpdict,'typeplot',...
    'movie','stepplot',5);

corr2(yfit,cuspamax')

feature = zeros(1,2048);
[~,I] = sort(IOPT);
feature(IOPT(I))=  COEFF;

feature = (1/norm(feature))*feature;