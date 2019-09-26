function x= DPCMDECODING(x)
%x=[150, 5, -6, 3, -8];
[~,b]=size(x);
for i=2:1:b
    x(1,i)=x(1,i)+x(1,i-1);
end