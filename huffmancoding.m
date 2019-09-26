clear;
clc;
sig = [1 1 1 1 3 3 2 2 4 5];%repmat([1 1 1 1 3 3 2 2 4 5],1,50000);
symbols = [1 2 3 4 5];
p = [0.4 0.2 0.2 0.1 0.1];
dict = huffmandict(symbols,p);
tic;
hcode = huffmanenco(sig,dict);
t1=toc;
tic;
dhsig = huffmandeco(hcode,dict);
t2=toc;
isequal(sig,dhsig)

