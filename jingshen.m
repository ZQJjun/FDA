clc
clear all

tic
Im=imread('2.jpg');
%Im=imread('C:\Users\Redmi\Desktop\paper\12.png');
I=double(Im)/255; 
%[m,n]=size(I,1,2);
%subplot(1,2,1);
figure,imshow(I,[]);title('Original image');

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
%=(dx1+dx2)/2;
d2=dx1.*(1-mean(Imax))+dx2.*mean(Imax);
%d2=sqrt(dx1.*dx2);
figure,imshow(d2);
imwrite(d2,'ed.jpg');
%d2=sqrt(dx1.*dx2);
%dx=sqrt(d1.*d2);
%kenel = [3 3];
%dm2 = minfilt2(d2,kenel);
%d = fastguidedfilter_color(I, dm2, 90, eps,6); 
%figure,imshow(dx),title('dx');
%b=(Imax+Imin)/2;
%dx = log(1+b).*((dx) .^ difft); 
%V1x=Imin;
%figure,imshow(V1x),title('V1x');
%V1=a.*V1x.^(1+difft/2);
%figure,imshow(V1),title('V1');
%d=dx1;
%d=dx2;
%figure,imshow(dx)
%d=d2;
%A=LAtm(I);
A=LAtm3(I);
%A=0.8;
%A=LAtm1(I);
%imwrite(A,'0.jpg');
%t=exp(-d2);
V=A.*(1-exp(-d2));
%J(:,:,1) = (I(:,:,1) - (1-t).*A)./t;
%J(:,:,2) = (I(:,:,2) - (1-t).*A)./t;
%J(:,:,3) = (I(:,:,3) - (1-t).*A)./t;

%am=imread('haze.png');
%a=double(am)/255; 
%大气光幕融合
%Vc=Imin.*(Imin)+V.*(1-(Imin));

%Vc=V1x.*(diff)+V2.*(1-diff);
%Vc=(Imin+V2)/2;
%Vc=V1x.*(a)+V2.*(1-a);
%V5 = minfilt2(Vc,kenel);
%Vc = fastguidedfilter_color(I, V5, 90, eps,6); 
%figure,imshow(Vc),title('Vc');
%imwrite(Vc,'Vc.bmp');
%V=Vc;
%kenel1=[25,25];
%Vc1=maxfilt2(Vc,kenel1);
%Vc1=ordfilt2(Vc,900,ones(30,30));
%Vm=mean(Vc1);

%V=Imin;
%V=(1-mean(mean((difft)))).*V1x;
%V=min(Vc,Vm);
%V=(Imin+V)/2;
imwrite(V,'V.jpg');
%L=diff2-(difft);
%V=min(Vc,0.8);
%figure,imshow(V),title('V');
%imwrite(V,'V.bmp');


%L=diff-0.6*difft;

%figure,imshow(V);
J=(I-V)./((1-V./A));
%p=[A.*(I-V)]./[L.*(A-V)];
toc
figure,imshow(J);
imwrite(J,'0.jpg');
%imwrite(J,'C:\Users\Redmi\Desktop\Ours2\15.png')
%[e,r,ns,mssim,psnr,s] = quality_evaluation(I,J)

