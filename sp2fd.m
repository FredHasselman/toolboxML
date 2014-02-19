%% Fred's Toolbox: Informed conversion of PSD Slope to Fractal Dimension
%
% The conversion formula was obtained by a nonlinear least squares fit 
% (Robust: Bisquare, Algorithm: Levenberg-Marquardt) of a hyperbolic tangent
% of the form: f(x) = a + b * tanh(x * c). 
%
% The 8 data points used in the fit were known Slope-FD pairs 
% (hence informed FD estimate), f.i. the ideal coloured noise spectra red,
% pink, white, blue and violet and pairs reported in the literature (results 
% from DLA-like model simulations). Additional constraints on the model were 
% imposed by placing the limits of Slope=-Inf at FD=1 and Slope=+Inf at FD=2.
%
% The fit results were:
%
% General model:
%      f(x) = a+b.*tanh(x.*c)
% Coefficients (with 95% confidence bounds):
%        a =         1.5  (1.5, 1.5)
%        b =      0.4243  (0.4234, 0.4251)
%        c =      0.8814  (0.8778, 0.8851)
% 
% Goodness of fit:
%   SSE: 4.672e-07
%   R-square: 1
%   Adjusted R-square: 1
%   RMSE: 0.0003057
%
%
% Filling in b = 14/33 and c = log(1+sqrt(2)) or equivalent c = asinh(1)
% gives the following fit results:
%
% Goodness of fit:
%   SSE: 1.045e-07
%   R-square: 1
%   Adjusted R-square: 1
%   RMSE: 0.0001222
%
%
% Please use this citation to refer to the conversion method:
%
% Hasselman, F (2013). When the Blind Curve is Finite: Formal, Intuitive and
% Informed Estimates of the Dimension of an Empirical Waveform. Frontiers
% in Physiology.
%
% Fred Hasselman - December 2012
% me@fredhasselman.com

function [fd] = sp2fd(sp)
   
   fd = 3/2 + (14/33).*tanh(sp.*log(1+sqrt(2)));
   
   %log(1+sqrt(2)) can be replaced by asinh(1): 
   %fd = 3/2 + (14/33).*tanh(sp.*asinh(1));
 
end