function [out] = resamplepad(Signal,Fs,rFs)
%%%------------------------------------------------------------------------------------------------------
%%% This is part of the pop_resample.m routine FROM EEGLAB [with adjustments by Fred Hasselman 2014]

% padding to avoid artifacts at the beginning and at the end
% Andreas Widmann May 5, 2011

%The pop_resample command introduces substantial artifacts at beginning and end
%of data when raw data show DC offset (e.g. as in DC recorded continuous files)
%when MATLAB Signal Processing Toolbox is present (and MATLAB resample.m command
%is used).
%Even if this artifact is short, it is a filtered DC offset and will be carried
%into data, e.g. by later highpass filtering to a substantial amount (easily up
%to several seconds).
%The problem can be solved by padding the data at beginning and end by a DC
%constant before resampling.


Signal = Signal(~isnan(Signal));
pnts   = length(Signal);

[q, p] = rat(pnts / (pnts/(Fs/rFs)), 1e-12); % Same precision as in resample

N = 10; % Resample default

% If pnts is odd, subtract 1 from the end of padded series
nPadBefore = ceil((max(p, q) * N) / q) * q; % # datapoints to pad, round to integer multiple of q for unpadding
nPadAfter  = nPadBefore * p / q; % # datapoints to unpad
if mod(pnts,2)>0
 nPadBeforeE = nPadBefore-1;
 nPadAfterE  = nPadAfter-1;
else
 nPadBeforeE = nPad;
 nPadAfterE  = nPadAfter;
end

tmpY = resample([Signal(ones(1, nPadBefore), :); Signal; Signal(end * ones(1, nPadBeforeE), :)], p, q);

out = tmpY(nPadAfter + 1:end - nPadAfterE, :); % Remove padded data

end
