%% Fred's Toolbox: Convert to Unit scale with custom min and max
% 
% Fred Hasselman - Februari 2011
% Contact: me@fredhasselman.com

function xunit = unit2(x,xmn,xmx)
 
 if ~exist('x','var')
  error('No data to convert');
 end;
 
 [r c]=size(x);
 x=x(:);

 if ~exist('xmn','var')
  xmn=min(x);
 end;
 
 if ~exist('xmx','var')
  xmx=max(x);
 end
 
 xun = (x-xmn)./(xmx-xmn);
 
 xunit=reshape(xun,r,c);
end