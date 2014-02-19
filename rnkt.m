%% Fred's UTILS: Sort data, return indices and ranks
%
%
% Fred Hasselman - Februari 2011
% Contact: me@fredhasselman.com


function out = rnkt(data)
    
[vs, vi] = sort(data);
[rnk, vr]= sort(vi);


out.sorted = [vs; vi; rnk]'; %sorted data in column 1; index in original vector; rank
out.ori_ranks  = [data; vr]';%original data order, with rank in column 2


end