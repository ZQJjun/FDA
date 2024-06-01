clc
clear all
close all
Im=imread('13.png');
I=double(Im)/255; 
[m,n]=size(I,1,2);
subplot(1,2,1);
imshow(I,[]);title('Original image')
w0=0.95;
wh=3;
%% dark_channel
I1=zeros(m,n);
for i=1:m
    for j=1:n
        I1(i,j)=min(I(i,j,:));
    end
end
Id1 = ordfilt2(I1,1,ones(wh,wh),'symmetric');

I1=zeros(m,n);
for i=1:m
    for j=1:n
        I1(i,j)=max(I(i,j,:));
    end
end
Id2 = ordfilt2(I1,9,ones(wh,wh),'symmetric');
y=Id1+Id2;
figure,imshow(y);
%%  A
dark_channel = Id1;
A_temp = max(max(dark_channel))*0.999;
A=A_temp;
tr= 1 - w0 * Id1/ A;
%% out 
t0=0.1;
t1 = max(t0,tr);
%t111=imhist(t1);
%figure,imhist(t111);
imwrite(t1,'t1.png');

I_out=zeros(m,n,3);
for k=1:3
    for i=1:m
        for j=1:n
            I_out(i,j,k)=(I(i,j,k)-A)/t1(i,j)+A;
        end
    end
end
subplot(1,2,2);
imshow(I_out,[]);title('Improved image')

