function Y = vanherk(X,N,TYPE,varargin)
%  VANHERK    Fast max/min 1D filter
%
%    Y = VANHERK(X,N,TYPE) performs the 1D max/min filtering of the row
%    vector X using a N-length filter.
%    The filtering type is defined by TYPE = 'max' or 'min'. This function
%    uses the van Herk algorithm for min/max filters that demands only 3
%    min/max calculations per element, independently of the filter size.
%
%    If X is a 2D matrix, each row will be filtered separately.
%    
%    Y = VANHERK(...,'col') performs the filtering on the columns of X.
%    
%    Y = VANHERK(...,'shape') returns the subset of the filtering specified
%    by 'shape' :
%        'full'  - Returns the full filtering result,
%        'same'  - (default) Returns the central filter area that is the
%                   same size as X,
%        'valid' - Returns only the area where no filter elements are outside
%                  the image.
%
%    X can be uint8 or double. If X is uint8 the processing is quite faster, so
%    dont't use X as double, unless it is really necessary.
%

% Initialization
[direc, shape] = parse_inputs(varargin{:});
if strcmp(direc,'col')
   X = X';
end
if strcmp(TYPE,'max')
   maxfilt = 1;
elseif strcmp(TYPE,'min')
   maxfilt = 0;
else
   error([ 'TYPE must be ' char(39) 'max' char(39) ' or ' char(39) 'min' char(39) '.'])
end

% Correcting X size
fixsize = 0;
addel = 0;
if mod(size(X,2),N) ~= 0   %表示如果size(X,2)不能被N整除，其中size(X,2)表示X的列数，N表示核的大小
   fixsize = 1;         %填充标志位
   addel = N-mod(size(X,2),N);%得到补0的个数
   if maxfilt
      f = [ X zeros(size(X,1), addel) ];%对X的每一行补0得到新的f,即多增加了addel列元素
   else   %最小滤波器，在最后补充与X最后一列相同元素，即增加了addel列元素
      f = [X repmat(X(:,end),1,addel)];%repmat返回一个X(:,end)*addel的矩阵，其中，X(:,end)得到X的最后一列元素
   end
else    %能被整除，即不用补零或非零值
   f = X;
end
lf = size(f,2); %得到新的f的列数
lx = size(X,2); %得到未填充的X的列数，如果size(X,2)能被N整除，则lf==lx
clear X         %把X从内存中清除

% Declaring aux. mat.
g = f;   %两个临时的缓冲器，初始化为相同的缓冲器
h = g;

% Filling g & h (aux. mat.)
%此处下面4句代码表示算法中的g(x)(或h(x))=f(x)
ig = 1:N:size(f,2);
ih = ig + N - 1;

g(:,ig) = f(:,ig);
h(:,ih) = f(:,ih);

if maxfilt
   for i = 2 : N
      igold = ig;
      ihold = ih;
      
      ig = ig + 1;
      ih = ih - 1;
      
      g(:,ig) = max(f(:,ig),g(:,igold));
      h(:,ih) = max(f(:,ih),h(:,ihold));
   end
else   %最小滤波器
   for i = 2 : N
      igold = ig;
      ihold = ih;
      
      ig = ig + 1;
      ih = ih - 1;
      
      g(:,ig) = min(f(:,ig),g(:,igold));
      h(:,ih) = min(f(:,ih),h(:,ihold));
   end
end
clear f

% Comparing g & h
if strcmp(shape,'full')   %如果是full，表示显示填充后的图片大小
   ig = [ N : 1 : lf ];
   ih = [ 1 : 1 : lf-N+1 ];
   if fixsize
      if maxfilt
         Y = [ g(:,1:N-1)  max(g(:,ig), h(:,ih))  h(:,end-N+2:end-addel) ];
      else
         Y = [ g(:,1:N-1)  min(g(:,ig), h(:,ih))  h(:,end-N+2:end-addel) ];
      end
   else
      if maxfilt
         Y = [ g(:,1:N-1)  max(g(:,ig), h(:,ih))  h(:,end-N+2:end) ];
      else
         Y = [ g(:,1:N-1)  min(g(:,ig), h(:,ih))  h(:,end-N+2:end) ];
      end
   end
   
elseif strcmp(shape,'same')
   if fixsize
      if addel > (N-1)/2  %(N-1)/2表示核的半径
         disp('hoi')      %floor是向下取整函数,例floor(3.5)=3
         ig = [ N : 1 : lf - addel + floor((N-1)/2) ];
         ih = [ 1 : 1 : lf-N+1 - addel + floor((N-1)/2)];
         if maxfilt   %ceil是向上取整函数,例ceil(3.5)=4
            Y = [ g(:,1+ceil((N-1)/2):N-1)  max(g(:,ig), h(:,ih)) ];
         else
            Y = [ g(:,1+ceil((N-1)/2):N-1)  min(g(:,ig), h(:,ih)) ];
         end
      else   
         ig = [ N : 1 : lf ];
         ih = [ 1 : 1 : lf-N+1 ];
         if maxfilt   
            Y = [ g(:,1+ceil((N-1)/2):N-1)  max(g(:,ig), h(:,ih))  h(:,lf-N+2:lf-N+1+floor((N-1)/2)-addel) ];
         else
            Y = [ g(:,1+ceil((N-1)/2):N-1)  min(g(:,ig), h(:,ih))  h(:,lf-N+2:lf-N+1+floor((N-1)/2)-addel) ];
         end
      end            
   else % not fixsize (addel=0, lf=lx) 
      ig = [ N : 1 : lx ];
      ih = [ 1 : 1 : lx-N+1 ];
      if maxfilt
         Y = [  g(:,N-ceil((N-1)/2):N-1) max( g(:,ig), h(:,ih) )  h(:,lx-N+2:lx-N+1+floor((N-1)/2)) ];
      else
         Y = [  g(:,N-ceil((N-1)/2):N-1) min( g(:,ig), h(:,ih) )  h(:,lx-N+2:lx-N+1+floor((N-1)/2)) ];
      end
   end      
   
elseif strcmp(shape,'valid')
   ig = [ N : 1 : lx];
   ih = [ 1 : 1: lx-N+1];
   if maxfilt
      Y = [ max( g(:,ig), h(:,ih) ) ];
   else
      Y = [ min( g(:,ig), h(:,ih) ) ];
   end
end

if strcmp(direc,'col')
   Y = Y';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [direc, shape] = parse_inputs(varargin)
direc = 'lin';
shape = 'same';
flag = [0 0]; % [dir shape]

for i = 1 : nargin
   t = varargin{i};
   if strcmp(t,'col') & flag(1) == 0
      direc = 'col';
      flag(1) = 1;
   elseif strcmp(t,'full') & flag(2) == 0
      shape = 'full';
      flag(2) = 1;
   elseif strcmp(t,'same') & flag(2) == 0
      shape = 'same';
      flag(2) = 1;
   elseif strcmp(t,'valid') & flag(2) == 0
      shape = 'valid';
      flag(2) = 1;
   else
      error(['Too many / Unkown parameter : ' t ])
   end
end