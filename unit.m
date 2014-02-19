%% Fred's Toolbox: Convert to Unit scale
% 
% Fred Hasselman - Februari 2011
% Contact: me@fredhasselman.com

function xunit = unit(x)
 
 if ~exist('x','var')
  error('No data to convert');
 end;

 [r c]=size(x);
 
 x=x(:);
 xmn=min(x);
 xmx=max(x);
 xun=(x-xmn)./(xmx-xmn);
 xunit=reshape(xun,r,c);
 
end