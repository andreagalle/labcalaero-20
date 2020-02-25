%M makes an elliptic wing taper distribution.


span=3;
npan=20;
dfi=pi/(2*(npan+1));
dspan=span/(npan+1);
C(1)=1;

for i=1:npan+1;
    B(i)=span*cos(dfi*i);
    C(i)=span*sin(dfi*i); 
end

C2=fliplr(C);
C3=C2(1:end);

for i=1:npan;
    T(i)=C3(i+1)/(C3(i)); 
end
