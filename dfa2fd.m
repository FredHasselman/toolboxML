%% Fred's Toolbox: Informed conversion of DFA Slope to Fractal Dimension
%
% The conversion formula was obtained by a nonlinear least squares fit 
% (Robust: Bisquare, Algorithm: Levenberg-Marquardt) of a hyperbolic tangent
% of the form: f(x) = a + b * tanh(x * c). 
%
% The 8 data points used in the fit were known Slope-FD pairs 
% (hence informed FD estimate), f.i. the ideal coloured noise spectra red,
% pink, white, blue and violet and pairs reported in the literature (results 
% from DLA-like model simulations). Additional constraints on the model were 
% imposed by placing the limits of Slope=0 at FD=2 and Slope=+Inf at FD=1.
%
% The fit results were:
% 
% General model:
%      f(x) = a+b.*(tanh(c.*x))
% Coefficients (with 95% confidence bounds):
%        a =           2  (2, 2)
%        b =     -0.9999  (-1, -0.9995)
%        c =       1.099  (1.098, 1.1)
% 
% Goodness of fit:
%   SSE: 7.093e-10
%   R-square: 1
%   Adjusted R-square: 1
%   RMSE: 2.663e-05
%
%
% Filling in b = -1 and a = 2 concludes in c=log(3)
%
% General model:
%      f(x) = 2-1.*(tanh(c.*x))
% Coefficients (with 95% confidence bounds):
%        c =       1.099  (1.098, 1.099)
% 
% Goodness of fit:
%   SSE: 1e-08
%   R-square: 1
%   Adjusted R-square: 1
%   RMSE: 5.773e-05
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

function [fd] = dfa2fd(sp)
   
   if sp < 0
    disp(' ')
    disp('----------------------------------------')
    disp('WARNING: Negative slope value entered...')
    disp('----------------------------------------')
    disp(' ')
   end

   fd = 2 - tanh(log(3).*sp);
 
end