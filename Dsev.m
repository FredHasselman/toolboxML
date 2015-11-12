%% Calculate FD using Sevcik's method
%
% Sevcik, C. (1998). A procedure to Estimate the Fractal Dimension of Waveforms
% Paper available at http://arxiv.org/pdf/1003.5266.pdf
%
% Requires unit.m from Fred's Toolbox available at http://fredhasselman.com
%
% Fred Hasselman february 2012
% Contact: me*fredhasselman*com | AT DOT

function [D] = Dsev(ts)

if ~isvector(ts)
 error('y must be a vector');
end

ts=ts(:);
N=length(ts);

D.FD=zeros(N,1);
D.sd=zeros(N,1);

for n = 2:N
 
 L = cumsum(sqrt( diff(unit(ts(1:n))).^2 + (1./(n-1).^2) ))  ;
 D.FD(n,1) = 1 + ( (log(L(end)+1e-5) - log(2)) / log((2*(n-1))+1e-5) );
 D.sd(n,1) = var(L) / (L(end)^2 * log((2*(n-1)^2)+1e-5));
 
 clear L
 
end

D.sd2 = nanstd(D.FD(:,1),1);

end