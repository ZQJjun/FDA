function [ A ] = LAtm( HazeImg )

sz = size(HazeImg);
w = sz(1);
h = sz(2);
Amc = max(HazeImg,[],3);
%  figure,imshow(Amc),title('preliminary Atm Veil')
% imwrite(Amc,'F:/result/Amc.png')
r1= ceil(min(h,w)/5);
se1 = strel('square',r1);
Amc_c1 = imclose(Amc,se1);
r2= ceil(min(h,w)/20);
se2 = strel('square',r2);
Amc_c2 = imclose(Amc,se2);
% % imwrite(Amc_c1,'F:/result/Amc_c.png')
% %  figure,imshow(Amc_c),title('closing Atm Veil')
Amc_c=(Amc_c1+Amc_c2)./2;
% Amc_c=Amc_c1;
% w = 3;
% sigma = [3,.7];
% A = bilateralfilter(Amc_c,w,sigma);
A = bilateralFilter2( Amc_c, Amc);
figure,imshow(A),title('A')
 imwrite(A,'Sun大气光未改.png')
end

