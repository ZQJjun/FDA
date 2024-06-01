function [ A ] = LAtm1( HazeImg )
sz = size(HazeImg);
w = sz(1);
h = sz(2);
A1 = max(HazeImg,[],3);
A2 = min(HazeImg,[],3);
%m=(A1+A2)/2;
bright=ordfilt2(A1,9,ones(3,3));  %亮通道
dark=ordfilt2(A2,1,ones(3,3));
%A=sqrt(A1+A2);
%A=(A1+A2)/2;
%b=medfilt2(A1,[3,3]);       %中值滤波
%c=(b+A2)/2;
c=(dark+bright)/2;              %取均值
%c=(1-A1).*dark+A1.*bright;
%r1= ceil(min(h,w)/5);
%se1 = strel('square',r1);
%Amc = imclose(b,se1);

%A = bilateralFilter2(c, Amc);
%A=(A+bright)/2;

%A=c;
r1= ceil(min(h,w)/5);
se1 = strel('square',r1);
Amc = imclose(c,se1);

%A = bilateralFilter2(c, Amc);
%A = guidedfilter(c, Amc, 90, eps);
A = fastguidedfilter_color(HazeImg, Amc, 90, eps,6);
imwrite(A,'改进局部大气光.png')

%A=b;
%A=A1;

end