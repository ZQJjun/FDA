function [ A ] = LAtm1( HazeImg )
sz = size(HazeImg);
w = sz(1);
h = sz(2);
A1 = max(HazeImg,[],3);
A2 = min(HazeImg,[],3);
%m=(A1+A2)/2;
bright=ordfilt2(A1,16,ones(4,4));  %亮通道
%A=sqrt(A1+A2);
%A=(A1+A2)/2;
b=medfilt2(A1,[3,3]);       %中值滤波
%c=(b+A2)/2;
%c=sqrt(b.*bright);              %取均值
%r1= ceil(min(h,w)/5);
%se1 = strel('square',r1);
%Amc = imclose(b,se1);

%A = bilateralFilter2(c, Amc);
%A=(A+bright)/2;

%A=c;
A=b;
%A=A1;

end