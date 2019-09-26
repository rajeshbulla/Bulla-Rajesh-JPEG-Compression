function dpcm=DPCM(a)
%a=[150,155,149,152,144];
s=size(a,2);
flip=1;
for i=1:1:s
    if(flip==1)
        dpcm(1,i)=a(1,i);
        flip=0;
    else
        dpcm(1,i)=a(1,i)-a(1,i-1);
    end
end
end










%{

indx = dpcmenco(sig,codebook,partition,predictor);
[indx,quants] = dpcmenco(sig,codebook,partition,predictor);

sig = dpcmdeco(indx,codebook,predictor);
[sig,quanterror] = dpcmdeco(indx,codebook,predictor);






clear;
clc;
a=[150,155,149,152,144];
s=size(a,2);
flip=1;
for i=1:1:s
    if(flip==1)
        dpcm(1,i)=a(1,i);
        flip=0;
    else
        dpcm(1,i)=a(1,i)-a(1,i-1);
    end
end
%}