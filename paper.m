clc
clear all
close all
Im=imread(['00639.png']);
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
%bao=1-difft./diff;
figure,imshow(diff);
%b=(Imax+Imin)/2;
dx1=(diff-min(diff(:))./(max(diff(:))-min(diff(:)))*diff);
%figure,imshow(dx1),title('dx1');
%d1=dx1;
%a=size(m,n);
%b=size(m,n);
%for i=1:m
    % for j=1:n
      %   if difft(i,j)<=mean(difft)
            %   a(i,j)=exp((-difft(i,j)));
             %  b(i,j)=exp((-difft(i,j)));
             %  else
              % a(i,j)=1-difft(i,j);
              % b(i,j)=1-difft(i,j);
              %a(i,j)=1;
              %b(i,j)=1;
        % end
       
    %end
%end

%d1=a.*(dx1) .^ (1-difft/2);
%figure,imshow(d1),title('d1');
dx2=(diff2-min(diff2(:))./(max(diff2(:))-min(diff2(:)))*diff2);
%figure,imshow(dx1),title('dx2');
%d2=b.*((dx2) .^ (1+difft/2)); 
%figure,imshow(d2),title('d2');
%d2=0;
%d2=dx2;
%d=sqrt(dx1+dx2);
d=(dx1+dx2)/2;
%d=dx1;
%d=dx2;
%kenel = [5 5];
%d2 = minfilt2(dx,kenel);
%d = fastguidedfilter_color(I, d2, 90, eps,6); 
%figure,imshow(dx),title('dx');
%b=(Imax+Imin)/2;
%dx = log(1+b).*((dx) .^ difft); 
%V1x=diff;
%figure,imshow(V1x),title('V1x');
%V1=a.*V1x.^(1+difft/2);
%figure,imshow(V1),title('V1');

%figure,imshow(dx)
A=LAtm3(I);

%imwrite(A,'0.jpg');
V=A.*(1-exp(-d));
%V=0.8*V1x;
%V=V1x;
%L=diff-0.6*difft;

figure,imshow(V);
J=(I-V)./((1-V./A));
figure,imshow(J);
imwrite(J,'1.bmp')
%[e,r,ns,mssim,psnr,s] = quality_evaluation(img1,J)

