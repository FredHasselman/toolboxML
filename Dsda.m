function D = Dsda(z)
%Compute standardized dispersion statistic at each bin size
%Assumes series is an integer power of 2 in length.
%Based on Relative Dispersion Statistic described in
%Bassingthwaighte, J. B., Liebovitch, L. S., & West, B. J.  (1994).
%    Fractal physiology.  New York: Oxford University Press.
%see
%Holden, J. G. (2005).  Gauging the fractal dimension of response times from cognitive tasks.
%    In M. A. Riley & G.  C. Van Orden (Eds.), Contemporary nonlinear methods for behavioral
%    scientists: A webbook tutorial, 267-318. At http://www.nsf.gov/sbe/bcs/pac/nmbs/nmbs.pdf
%Jay Holden, 7/2006

% Fred Hasselman 20/5/2011 - Added some output
% me@fredhasselman.com

%% Error Checking, Verify single column of data


    [zr,zc] = size(z);
    if zr > 1 && zc > 1
        
         error('Matrix Input: Assumes a single column of data.')
         
    elseif zr==1
        
        z = z';
        warning('Row Input: Assumes a single column of data.')
        
    else   
    end

%% Verify data is an integer power of 2 in length

    len_p2=log2(length(z));  % find out how long it is
    
    if mod(len_p2,1)~=0 %Integer test, make sure no decimal remainder after dividing by 1
        
        error('Series must be an integer power of 2 in length.')
        
    else
    end

%% Verify Z-score format, if not fix.

    if abs(mean(z))>=1e-6 || std(z,1)~=1
        
        mu=mean(z); sigma=std(z,1);
        z = (z - mu)./ sigma;
       % disp('Data was normalized for analysis.')
        
    else
    end
    
%% Begin Standardized Dispersion

dispersion=zeros(len_p2,1); % This initalizes the dispersion vector

             for j=1:(len_p2-1)
                % computes bin size for each scale
                
                bin_size=length(z)/pow2(j);
                k = fix(length(z)/bin_size);
                start=1;
                segment_means=zeros(k,1);
                    
                    for i=1:k  %Compute mean for each bin
                        
                        segment_means(i,1)=mean(z(start:start+bin_size-1,1));
                        start=start+bin_size;
                    end
                    
                %Compute std (population formula) across the bins
                dispersion(j,1)=std(segment_means,1);
                
             end
            
           %Get the standard deviation of all points, (bins of 1 data
           %point). Should equal 1, so round to emiminate e-15 output
           dispersion(len_p2,1)=round(std(z,1));    

%% Finish up
%create the bin size vector 
 bin_sz=(0:len_p2-1)';
 
 % flip vector since it was done from large to small samples and
 % is plotted from small to large samples.
 
 disper=flipud(log2(dispersion));
 
 
r_trend1 = corrcoef(bin_sz, disper);
coefs1   = polyfit(bin_sz, disper,1);
r_line1  = polyval(bin_sz, disper);

% Fit over nbins-mb
mb=2;
r_trend2 = corrcoef(bin_sz(2:end-mb), disper(2:end-mb));
coefs2   = polyfit(bin_sz(2:end-mb), disper(2:end-mb),1);
r_line2  = polyval(bin_sz(2:end-mb), disper(2:end-mb));


if nargout
    D.bins = bin_sz;
    D.disp = disper;
    D.reg  = coefs1;
    D.r2   = r_trend1(1,2)^2;
    D.line = r_line1;
    D.regS = coefs2;
    D.r2S  = r_trend2(1,2)^2;
    D.lineS=r_line2;
    
    % This needs to tested more thoroughly:
    % Decide on best fit using r^2
%     if isnan(D.r2S) || isnan(D.r2) 
%      D.slR2 = 0;
%     end
%     
%     if D.r2S > D.r2
      D.sl = coefs1(1);
%     elseif D.r2S < D.r2
      D.sl2 = coefs2(1);
%     end
     
    
end




 
end


 
            