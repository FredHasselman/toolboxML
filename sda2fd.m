%% Fred's Toolbox: Informed conversion of SDA Slope to Fractal Dimension
%
% The conversion formula was obtained by a nonlinear least squares fit
% (Robust: Bisquare, Algorithm: Levenberg-Marquardt) of a hyperbolic tangent
% of the form: f(x) = a + b * tanh(x * c + d). In this case the parameters were identified as multiples of d.
%
% The data points used in the fit were known Slope-FD pairs
% (hence informed FD estimate), f.i. the ideal coloured noise spectra red,
% pink, white, blue and violet.
%
% The fit results were:
%
% General model:
%      f(x) = (3*d)-(2*d).*tanh(x.*(2*d)+d)
% Coefficients (with 95% confidence bounds):
%        d =       0.502  (0.4972, 0.5069)
%
% Goodness of fit:
%   SSE: 0.001804
%   R-square: 0.9982
%   Adjusted R-square: 0.9982
%   RMSE: 0.01734
%
% Please use this citation to refer to the conversion method:
%
% Hasselman, F (2013). When the Blind Curve is Finite: Formal, Intuitive and
% Informed Estimates of the Dimension of an Empirical Waveform. Frontiers
% in Physiology.
%
% Fred Hasselman - December 2012
% me@fredhasselman.com

function [fd] = sda2fd(sp)

if ((sp < -1) | (sp > 0))
    disp(' ')
    disp('----------------------------------------')
    disp('WARNING: Slope out of range...')
    disp('----------------------------------------')
    disp(' ')
end

 %fd = (3/2)-tanh(sp+(1/2));

 fd = 1-sp;
 
% disp('Note: Result is rounded to 3 significant digits')
% 
% fd = roundsd((3/2)-tanh(sp+(1/2)),3);
% 
%  function y=roundsd(x,n,~)
%   %ROUNDSD Round with fixed significant digits
%   %	ROUNDSD(X,N) rounds the elements of X towards the nearest number with
%   %	N significant digits.
%   %
%   %	ROUNDS(X,N,METHOD) uses following methods for rounding:
%   %		'round' - nearest (default)
%   %		'floor' - towards minus infinity
%   %		'ceil'  - towards infinity
%   %		'fix'   - towards zero
%   %
%   %	Examples:
%   %		roundsd(0.012345,3) returns 0.0123
%   %		roundsd(12345,2) returns 12000
%   %		roundsd(12.345,4,'ceil') returns 12.35
%   %
%   %	See also Matlab's function ROUND.
%   %
%   %	Author: Fran?ois Beauducel <beauducel@ipgp.fr>
%   %	  Institut de Physique du Globe de Paris
%   %	Acknowledgments: Edward Zechmann, Daniel Armyr
%   %	Created: 2009-01-16
%   %	Updated: 2010-03-17
%   
%   %	Copyright (c) 2010, Fran?ois Beauducel, covered by BSD License.
%   %	All rights reserved.
%   %
%   %	Redistribution and use in source and binary forms, with or without
%   %	modification, are permitted provided that the following conditions are
%   %	met:
%   %
%   %	   * Redistributions of source code must retain the above copyright
%   %	     notice, this list of conditions and the following disclaimer.
%   %	   * Redistributions in binary form must reproduce the above copyright
%   %	     notice, this list of conditions and the following disclaimer in
%   %	     the documentation and/or other materials provided with the distribution
%   %
%   %	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
%   %	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
%   %	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
%   %	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
%   %	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
%   %	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
%   %	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
%   %	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
%   %	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
%   %	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
%   %	POSSIBILITY OF SUCH DAMAGE.
%   
%   % Fred Hasselman March 2013 - Some minor adjustments
%   
%   narginchk(2,3)
%   
%   if ~isnumeric(x)
%    error('X argument must be numeric.')
%   end
%   
%   if ~isnumeric(n) || numel(n) ~= 1 || n < 0 || mod(n,1) ~= 0
%    error('N argument must be a scalar positive integer.')
%   end
%   
%   opt = {'round','floor','ceil','fix'};
%   
%   if nargin < 3
%    method = opt{1};
%   else
%    if ~ischar(method) || ~ismember(opt,method)
%     error('METHOD argument is invalid.')
%    end
%   end
%   
%   og = 10.^(floor(log10(abs(x)) - n + 1));
%   y = feval(method,x./og).*og;
%   y(x==0) = 0;
%   
%   
%  end
end