%% Fred's Toolbox: Convert scale to [-1, 1]
%
% X      = [-1,1]
% DATA   = DATA to be converted to: min(DATA)=min(X); mid(DATA)=mid(X); MAX(DATA)=MAX(X)
% out    = DATA scaled to range X and reshaped as DATA
%
% Fred Hasselman - Februari 2011
% Contact: me@fredhasselman.com

function out = minplus1(data)
    [r c]=size(data);
    X=[-1,1]; data=data(:);
    out = (((data - min(data)) * (max(X) - min(X))) / (max(data) - min(data))) + min(X);
    out=reshape(out,r,c);
end

