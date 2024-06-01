clc
clear all
close all
Im=imread('he1.png');
I=double(Im)/255; 
[m,n]=size(I,1,2);
subplot(1,2,1);
imshow(I,[]);title('Original image');

%% 最大与最小通道
%I1=zeros(m,n);
%for i=1:m
   % for j=1:n
    %    Imin(i,j)=min(I(i,j,:));
       % diff(i,j)=Imin(i,j,:);
    %end
%end
Imax=max(I,[],3);
Imin=min(I,[],3);
diff=Imin;
diff2=Imax;
difft=Imax-Imin;
figure,imshow(diff);
%b=(Imax+Imin)/2;
Vx1=(diff2-min(diff2(:))./(max(diff2(:))-min(diff2(:)))*diff2);
%figure,imshow(dx1),title('dx1');
%d1=dx1;
a=size(m,n);
b=size(m,n);
for i=1:m
     for j=1:n
         if difft(i,j)<=mean(difft)
               a(i,j)=difft(i,j);
               b(i,j)=log(1+difft(i,j));
               else
               a(i,j)=log(1+difft(i,j));
               b(i,j)=log(1+difft(i,j));
              %a(i,j)=1;
              %b(i,j)=1;
         end
       
    end
end

V1=a.*(Vx1) .^ (1-difft/2);
%figure,imshow(d1),title('d1');
Vx2=(diff2-min(diff2(:))./(max(diff2(:))-min(diff2(:)))*diff2);
%figure,imshow(dx1),title('dx2');
V2=b.*((Vx2) .^ (1+difft/2)); 
%figure,imshow(d2),title('d2');
%d2=0;
%d2=dx2;
%dx=(d1+d2)/2;
%figure,imshow(dx),title('dx');
%b=(Imax+Imin)/2;
%dx = log(1+b).*((dx) .^ difft); 
%V2=diff;
%figure,imshow(dx)
A=LAtm(I);
%V=A.*(1-exp(-dx));
V=(V1+V2)/2;
kenel = [5 5];
V5 = minfilt2(V,kenel);
Vc = fastguidedfilter_color(I, V5, 90, eps,6); 
V=Vc;
%L=diff-0.6*difft;


figure,imshow(V);
J=(I-V)./((1-V./A));
figure,imshow(J);

