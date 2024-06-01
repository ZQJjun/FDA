function [ A ] = LAtm1( HazeImg )
sz = size(HazeImg);
w = sz(1);
h = sz(2);
A1 = max(HazeImg,[],3);
A2 = min(HazeImg,[],3);
%m=(A1+A2)/2;
bright=ordfilt2(A1,16,ones(4,4));  %亮通道
%dark=ordfilt2(A2,)
%A=sqrt(A1+A2);
%A=(A1+A2)/2;
b=medfilt2(A1,[4,4]);       %中值滤波

c=sqrt(bright.*b);
%A=b;
A=c;
%A=b;
%A=A1;

end