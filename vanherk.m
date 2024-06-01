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
if mod(size(X,2),N) ~= 0   %��ʾ���size(X,2)���ܱ�N����������size(X,2)��ʾX��������N��ʾ�˵Ĵ�С
   fixsize = 1;         %����־λ
   addel = N-mod(size(X,2),N);%�õ���0�ĸ���
   if maxfilt
      f = [ X zeros(size(X,1), addel) ];%��X��ÿһ�в�0�õ��µ�f,����������addel��Ԫ��
   else   %��С�˲���������󲹳���X���һ����ͬԪ�أ���������addel��Ԫ��
      f = [X repmat(X(:,end),1,addel)];%repmat����һ��X(:,end)*addel�ľ������У�X(:,end)�õ�X�����һ��Ԫ��
   end
else    %�ܱ������������ò�������ֵ
   f = X;
end
lf = size(f,2); %�õ��µ�f������
lx = size(X,2); %�õ�δ����X�����������size(X,2)�ܱ�N��������lf==lx
clear X         %��X���ڴ������

% Declaring aux. mat.
g = f;   %������ʱ�Ļ���������ʼ��Ϊ��ͬ�Ļ�����
h = g;

% Filling g & h (aux. mat.)
%�˴�����4������ʾ�㷨�е�g(x)(��h(x))=f(x)
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
else   %��С�˲���
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
if strcmp(shape,'full')   %�����full����ʾ��ʾ�����ͼƬ��С
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
      if addel > (N-1)/2  %(N-1)/2��ʾ�˵İ뾶
         disp('hoi')      %floor������ȡ������,��floor(3.5)=3
         ig = [ N : 1 : lf - addel + floor((N-1)/2) ];
         ih = [ 1 : 1 : lf-N+1 - addel + floor((N-1)/2)];
         if maxfilt   %ceil������ȡ������,��ceil(3.5)=4
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