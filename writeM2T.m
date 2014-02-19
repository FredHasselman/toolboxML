%% Fred's Toolbox: A simple write matrix to tab-delimited script... also see writeS2T
%
% Fred Hasselman - December 2011
% Contact: me@fredhasselman.com

function writeM2T(matrix,filename,header,fstr,trNaN,aOw)

%    p = inputParser;
%    defaultPermission  = 'a';
%    expectedPermission = {'a','a+','A','w','w+','W'};
% 
%    addRequired(p,'matrix',@ismatrix);
%    addRequired(p,'filename',@ischar);
% 
%    addOptional(p,'header',@ischar);
%    addOptional(p,'aOw',defaultPermission,@(x) any(validatestring(x,expectedPermission)));


if ~exist('matrix','var')
 error('no matrix')
end;

if ~exist('filename','var')
 error('no filename')
end;

[r c]  = size(matrix);
Nh     = numel(header);

fprintf('\n')
disp('------write matrix to TAB-delimited file------')
fprintf('\n')

disp('Settings:')

if Nh==0
 disp('- No headerline, assuming vars in columns')
 N=r;
else
 if Nh == c
  fprintf('- Assuming header indicates vars in columns: #elements(%u) == #columns(%u)',Nh,c);
  header = ['row',header];
  N=r;
 elseif Nh == r
  fprintf('- Assuming header indicates vars in rows: #elements(%u) == #columns(%u)',Nh,r);
  header = ['col',header];
  N=c;
  matrix=matrix';
 elseif (Nh~=r)&&(Nh~=c)
  error('writeM2T:header_rc','Mismatch between length of header (%u) and size of matrix (r=%u,c=%u)',Nh,r,c);
 end
end

if ~exist('fstr','var')||isempty(fstr)
 disp('- default to %.4f')
 fstr='%.4f';
end;

if ~exist('trNaN','var')||isempty(trNaN)
 disp('- writing NaN as NaN')
 trNaN='NaN';
else
 disp(['- writing NaN as ',trNaN])
end;

if ~exist('aOw','var')||isempty(aOw)
 disp('- file append mode')
 aOw='a';
end;

if exist(filename,'file')
 if ismember(aOw,{'a','a+','A'})
  fprintf('\nAppending matrix to existing file: %s\n',filename)
 end
 if ismember(aOw,{'w','w+','W'})
  warning('writeM2T:writeover','With permission: writing matrix over existing file: %s',filename);
 end
end

if ~ismember(aOw,{'a','a+','A','w','w+','W'})
 error('writeM2T:permission','Unknown file permission: ''%s''',aOw)
end

if ispc==1
 endL='\r\n';
else
 endL='\n';
end

try
 fid=fopen(filename,aOw);
catch ME
 ME
end



if Nh>0
 %Update
 Nhead=numel(header);
 %Write header with fieldnames
 for h=1:Nhead-1
  fprintf(fid, '%s\t ',strtrim(header{h}));
 end
 fprintf(fid, ['%s',endL],strtrim(header{h+1}));
else
 Nh=c;
end

%Write fields
for i=1:N
 
 fprintf(fid, '%.0f\t', i);
 
 for h=1:(Nh-1)
  
  if isnan(matrix(i,h))==1
   fprintf(fid,'%s\t',trNaN);
  else
   fprintf(fid, [fstr,'\t'],matrix(i,h));
  end
  
 end
 
 if isnan(matrix(i,h+1))==1
  fprintf(fid,['%s',endL],trNaN);
 else
  fprintf(fid,[fstr,endL],matrix(i,h+1));
 end
 
end

fclose(fid);

fprintf('\n')
disp('---------------------done---------------------')
fprintf('\n')

end