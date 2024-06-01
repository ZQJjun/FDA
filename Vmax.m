clc
clear all

tic
Im=imread('1.png');
%Im=imread('C:\Users\Redmi\Desktop\合成\3.png');
%Im=imread('C:\Users\Redmi\Desktop\paper\16.png');
I=double(Im)/255; 
%[m,n]=size(I,1,2);
%subplot(1,2,1);
figure,imshow(I);title('Original image');

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
%diff=Imin;
%diff2=Imax;
%figure,imshow(diff);
%difft=Imax-Imin;
%bao=1-difft./diff;
%b=(Imax+Imin)/2;
%dx1=(diff-min(diff(:))./(max(diff(:))-min(diff(:)))*diff);
dx1=(Imin-min(Imin(:))./(max(Imin(:))-min(Imin(:)))*Imin);
%figure,imshow(dx1),title('dx1');
%d1=dx1;
%a=size(m,n);
%b=size(m,n);
%for i=1:m
   %  for j=1:n
       %  if difft(i,j)<=mean(difft)
       %        a(i,j)=exp((-difft(i,j)));
         %      b(i,j)=exp((-difft(i,j)));
         %      else
         %      a(i,j)=1-difft(i,j);
          %     b(i,j)=1-difft(i,j);
              %a(i,j)=1;
              %b(i,j)=1;
       %  end
       
   % end
%end

%d1=a.*(dx1) .^ (1-difft/2);
%figure,imshow(d1),title('d1');
%dx2=(diff2-min(diff2(:))./(max(diff2(:))-min(diff2(:)))*diff2);
dx2=(Imax-min(Imax(:))./(max(Imax(:))-min(Imax(:)))*Imax);
%figure,imshow(dx1),title('dx2');
%d2=b.*((dx2) .^ (1+difft/2)); 
%figure,imshow(d2),title('d2');
%d2=0;
%d2=dx2;
%dx=(dx1+dx2)/2;
dx=sqrt(dx1.*dx2);
%kenel = [1 1];
%d2 = minfilt2(dx,kenel);
%d = fastguidedfilter_color(I, d2, 90, eps,6); 
d=dx;
%figure,imshow(dx),title('dx');
%b=(Imax+Imin)/2;
%dx = log(1+b).*((dx) .^ difft); 
%V1x=Imin;
%figure,imshow(V1x),title('V1x');
%V1=a.*V1x.^(1+difft/2);
%figure,imshow(V1),title('V1');

%figure,imshow(dx)
%A=LAtm(I);
%A=LAtm1(I);
%A=LAtm(I);
%A=LAtm(I);
%A=LAtm2(I);
A=LAtm(I);
figure,imshow(A);
%imwrite(A,'0.jpg');
V2=A.*(1-exp(-d));

%am=imread('haze.png');
%a=double(am)/255; 
%大气光幕融合
%Vc=mean(Imin).*(Imin)+V2.*(1-mean(Imin));
Vc=Imin.*(Imin)+V2.*(1-Imin);

%Vc=V1x.*(diff)+V2.*(1-diff);
%Vc=(Imin+V2)/2;
%Vc=V1x.*(a)+V2.*(1-a);
kenel = [3 3];
V5 = minfilt2(Vc,kenel);
Vc = fastguidedfilter_color(I, V5, 90, eps,6); 
%figure,imshow(Vc),title('Vc');
%imwrite(Vc,'Vc.bmp');
%V=Vc;
%kenel1=[25,25];
%Vc1=maxfilt2(Vc,kenel1);
Vc1=ordfilt2(Vc,900,ones(30,30));
Vm=mean(Vc1);
%Vm = bilateralFilter2(Vm, Vc);


%V=(1-mean(mean((difft)))).*V1x;
%V=min(Vc,Vm);
%V=Vc;
%imwrite(V,'1.jpg');
%L=diff2-(difft);
%V=min(Vc,0.8);
%figure,imshow(V),title('V');
%imwrite(V,'V.bmp');
%kenel = [1 1];
%V2 = minfilt2(V,kenel);
%V = fastguidedfilter_color(I, V2, 90, eps,6);

%L=diff-0.6*difft;

%figure,imshow(V);
J=(I-V)./((1-V./A));
%p=[A.*(I-V)]./[L.*(A-V)];
toc
figure,imshow(J);
imwrite(J,'0.jpg');
imwrite(J,'C:\Users\Redmi\Desktop\合成图像\ours4\3.png')
%imwrite(J,'C:\Users\Redmi\Desktop\Ours4\16.png')
%[e,r,ns,mssim,psnr,s] = quality_evaluation(I,J)

