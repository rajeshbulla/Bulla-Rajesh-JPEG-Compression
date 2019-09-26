clear;
clc;
 %IN = [22,1,10,-10,-2,0,0,0,2,1,7,0,0,0,0,0,0,0,-1,-1,-5,-1,2,2,0,0,0,0,0,0,0,0,0,-1,0,3,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
 %OUT = invzigzag(IN,8,8);

I=imread('j268.jpg');%rajeshimage.tif');
I=rgb2gray(I);
[ix,iy]=size(I);
ix=8*(floor(ix/8));
iy=8*(floor(iy/8));
A=I(1:ix,1:iy);
filesize=iy/8;
filesize=filesize-1;
%A=1-A;
blockSize=8;
jump=7;
p=1;
qq=1;
rowSize=size(A,1);
colSize=size(A,2);
tic;
for i=1:blockSize:rowSize
     for j=1:blockSize:colSize 
           B(i:i+jump,j:j+jump) = dct2(A(i:i+jump,j:j+jump));
           Bq(i:i+jump,j:j+jump)=quantization(B(i:i+jump,j:j+jump),blockSize);
             ACzigzagstorage(p,1:63)=zzag(Bq(i:i+jump,j:j+jump));
             ACvector(1,qq:qq+62)= ACzigzagstorage(p,1:63);
           DCvalues(1,p)=Bq(i,j);
           p=p+1;
           qq=qq+63;
           
     end
end

DPCMcoding=DPCM(DCvalues);

[a, symbols] = hist(DPCMcoding, unique(DPCMcoding));
        z=size(a,2);
        for i=1:1:z
            probabilities(i,1)=a(i)/size(DPCMcoding,2);
        end
        
          %the process of DC coefficients encoding.....................
        DCdict = huffmandict(symbols,probabilities);
        DChcode = huffmanenco(DPCMcoding,DCdict);
        
        %the process of AC coefficients encoding.....................
     
        [ACa, ACsymbols]=hist(ACvector, unique(ACvector));
        ACz=size(ACa,2);
        for i=1:1:ACz
             ACprobabilities(i,1)=ACa(i)/size(ACvector,2);
        end
          ACdict = huffmandict(ACsymbols,ACprobabilities);
          AChcode = huffmanenco(ACvector,ACdict);
        
        
         %FOR AC coefficients encoding is over........................
         encodingtime=toc;
         
         %----------------------------rncoding is over--------------------
          
        
        %........................................AC Decoding...............
   tic; 
        ACDhsig = huffmandeco(AChcode,ACdict);
      
        
        %........................................AC Decoding...............
        dhsig = huffmandeco(DChcode,DCdict);
        DPCMdecode=DPCMDECODING(dhsig);
        k=1;
        q=1;
        aa=1;
        [row col]=size(DPCMdecode);
        for i=1:1:16
            for j=1:1:16
            original(q,k)=DPCMdecode(aa);
            k=k+jump;
            aa=aa+1;
            end
            q=q+jump;
            k=1;
        end
        
        %.............combining both AC and DC coefficients......
        
          %isequal(ACvector,ACDhsig)
         [row col]=size(ACDhsig);
         k=1;
         flip=1;
         g=1;
         h=1;
        for i=1:63:col
            DCV=DPCMdecode(1,k);
            temp=DCV;
            %k=k+1;
            Block(1,1:63)=ACDhsig(1,i:i+62);      %%%%%look at it
            temp(1,2:64)=Block(1,1:63);
            final=invzigzag(temp,8,8);
            if(flip<=filesize)
                rem(g:g+7,h:h+7)=final;
                h=h+8;
                flip=flip+1;
            else
                
                rem(g:g+7,h:h+7)=final;
                g=g+8;
                h=1;
                flip=1;
            end
           k=k+1; 
        end
       
        blocksize=8;
        [rowSize, colSize]=size(rem);
for i=1:blockSize:rowSize
     for j=1:blockSize:colSize 
        %performing the dequantization
        Bnew(i:i+jump,j:j+jump)=invQuantization(rem(i:i+jump,j:j+jump),blockSize);
        %performing the inverse DCT
        ASnew(i:i+jump,j:j+jump) = round(idct2(Bnew(i:i+jump,j:j+jump)));
     end
end
 decodingtime=toc;     

  rimage=uint8(ASnew);
  %subplot(2 2 1)
  %title('original image');
  figure, imshow(I);
  %subplot(2 2 1);
  %title('reconstructed image');
  figure, imshow(rimage);
       %isequal(DPCMcoding,dhsig)
        
       
        