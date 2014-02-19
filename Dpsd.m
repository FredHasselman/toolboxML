%% Fred's Toolbox: Get spectral slope for trial series - check defaults - some preprocessing
%
% Returns several PSD-based FD estimates, and access to calculation steps
% 
%
% <SETTINGS> are stored in: Dsp.set:
%
% P, F, log10P, log10F  =  Power and Frequency vectors used to get estimates
% Fs, Fr, W, n          =  PSD Settings (see below)
% low, sQ25, sW         =  Method settings
% 
%
% Rest of the structure is built up as: Dsp.<METHODNAME>.<MEASURE> 
%
% <METHODNAME> 
% glob                   = Check the global slope first for anti-persistence
% Q25                    = Dsp.set.sQ25 lowest frequencies starting from Dsp.set.low
% Wijn                   = Wijnants' method Dsp.set.sW lowest frequencies starting from Dsp.set.low
%
% <METHODNAME>.<MEASURE>
%  
% <METHODNAME>.reg       = Result of polyfit 1st order, use with polyval 
% <METHODNAME>.r2        = r^2 of polyfit
% <METHODNAME>.line      = Vector of result of polyfit evaluated with polyval on <METHODNAME>'s log10F fitrange
% <METHODNAME>.alpha     = <METHODNAME>.reg(1)
% <METHODNAME>.FD        = Transforms spectral slope to FD estimate by general heuristic: (5-alpha)/2
% <METHODNAME>.FDhas     = Transforms spectral slope to FD estimate by Hasselman's formula (sp2fd.m)
% 
%
% Fred Hasselman - January 2011
% Contact: me@fredhasselman.com


function [Dsp] = Dpsd(ts)

    s = warning('off', 'Dpsd:antiP');

    % Dsp.Set
    Dsp.set.Fs   = 1;                           %Will change Fr to Hz instead of RAD when calling periodogram
    Dsp.set.low  = 1;                           %Change this to set lowest frequency on fitrange to other value
    Dsp.set.sW   = 50;                          %Wijnants method for continuous processes: fit to lowest sW frequencies
                                                %This is a rule of thumb! See Wijnants et al. (2013) Fractal Physiology)
    Dsp.set.pnorm= {};                          %Normalize power before fit? If yes, use a function name, otherwise {}
    Dsp.set.antiP= .20;                         %Criterion for global slope antipersistent noise

    
    if ~exist('ts','var')||isempty(ts),
        warning('Dsp:TSsize','No data in time series... \n Returning settings for n=1024')
        Dsp.set.n    = 1024;                       
        Dsp.set.Fr   = Dsp.set.n/2;                
        Dsp.set.W    = tukeywin(Dsp.set.n);        
        Dsp.set.sQ25 = round(((Dsp.set.Fr/2)-Dsp.set.low)*.25); 
        return
    end;
    
    ts=ts(:);
    [n,d]=size(ts);
    if d ~=1; error('Dsp:TSdim','Use a one dimensional ts vector'); end 
    ts=detrend(ts);
    ts=zscore(ts,1);
    if mod(log2(n),1)~=0; ts=prep(ts,2^nextpow2(n)); end
    [Dsp.set.n,d]=size(ts);
    
    % Use n to set 
    Dsp.set.Fr   = Dsp.set.n/2;                             %Periodogram will give Fr/2 frequencies
    Dsp.set.W    = tukeywin(Dsp.set.n);                     %Simple window
    Dsp.set.sQ25 = round(((Dsp.set.Fr/2)-Dsp.set.low)*.25); %Quartile: fit to 25% lowest frequencies
      
    % Use periodogram with simple window
    [Dsp.set.Power Dsp.set.Freq]  = periodogram(ts,Dsp.set.W,Dsp.set.Fr,Dsp.set.Fs);
    
    Dsp.set.Power(1) = []; Dsp.set.Freq(1)  = []; 
    Dsp.set.log10P   = log10(Dsp.set.Power); 
    Dsp.set.log10F   = log10(Dsp.set.Freq);

    %If the global slope is positive, maybe we are dealing with blue or violet noise
    if ~isempty(Dsp.set.pnorm)
     try
      Dsp.set.log10P(Dsp.set.low:end)=Dsp.set.pnorm(Dsp.set.log10P(Dsp.set.low:end));
     catch ME
      disp(ME)
     end
    end
    Dsp.glob.reg  = polyfit(Dsp.set.log10F(Dsp.set.low:end),Dsp.set.log10P(Dsp.set.low:end),1);
    r_trend       = corrcoef(Dsp.set.log10F(Dsp.set.low:end),Dsp.set.log10P(Dsp.set.low:end)); 
    Dsp.glob.r2   = r_trend(1,2)^2;
    Dsp.glob.line = polyval(Dsp.glob.reg,Dsp.set.log10F(Dsp.set.low:end));
    Dsp.glob.alpha= Dsp.glob.reg(1);
    
    if Dsp.glob.alpha > Dsp.set.antiP
     warning('Dsp:antiP','Global slope > %1.2f ...assuming anti-persitent correlations',Dsp.set.antiP)
     Dsp.set.log10F  = fliplr(Dsp.set.log10F);
    end
    
    
    % Dsp.Q25
    Dsp.Q25.reg  = polyfit(Dsp.set.log10F(Dsp.set.low:Dsp.set.sQ25),Dsp.set.log10P(Dsp.set.low:Dsp.set.sQ25),1);
    r_trend      = corrcoef(Dsp.set.log10F(Dsp.set.low:Dsp.set.sQ25),Dsp.set.log10P(Dsp.set.low:Dsp.set.sQ25)); 
 %   Dsp.Q25.r2   = r_trend(1,2)^2;
    Dsp.Q25.line = polyval(Dsp.Q25.reg,Dsp.set.log10F(Dsp.set.low:Dsp.set.sQ25));
    Dsp.Q25.alpha= Dsp.Q25.reg(1);
    Dsp.Q25.FD   = (5- abs(Dsp.Q25.alpha))/2;
    Dsp.Q25.FDhas= sp2fd(Dsp.Q25.alpha);
    
    
    % Dsp.Wijn   
    Dsp.Wijn.reg  = polyfit(Dsp.set.log10F(Dsp.set.low:Dsp.set.sW),Dsp.set.log10P(Dsp.set.low:Dsp.set.sW),1);
    r_trend       = corrcoef(Dsp.set.log10F(Dsp.set.low:Dsp.set.sW),Dsp.set.log10P(Dsp.set.low:Dsp.set.sW)); 
    Dsp.Wijn.r2   = r_trend(1,2)^2; 
    Dsp.Wijn.line = polyval(Dsp.Wijn.reg,Dsp.set.log10F(Dsp.set.low:Dsp.set.sW));
    Dsp.Wijn.alpha= Dsp.Wijn.reg(1);
    Dsp.Wijn.FD   = (5- abs(Dsp.Wijn.alpha))/2;
    Dsp.Wijn.FDhas= sp2fd(Dsp.Wijn.alpha);
    
    if Dsp.glob.alpha > Dsp.set.antiP
     Dsp.set.log10F  = fliplr(Dsp.set.log10F);
    end
      
    warning(s);
    
end