clc
clear all
close all
Im=imread('7.png');
I=double(Im)/255; 
[m,n]=size(I,1,2);
subplot(1,2,1);
imshow(I,[]);title('Original image')
w0=0.95;
wh=3;
%% bright_channel
I1=zeros(m,n);
for i=1:m
    for j=1:n
        I1(i,j)=max(I(i,j,:));
    end
end
Id1 = ordfilt2(I1,9,ones(wh,wh),'symmetric');

%%  A
dark_channel = Id1;
A_temp = max(max(dark_channel))*0.999;
A=A_temp; 
tr= (A-Id1)/(A-1);
%% out 
t0=0.1;
t1 = max(t0,tr);
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