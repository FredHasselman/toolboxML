%% Script to prep data for spectral analysis -> Removes datapoints or pads with zero to front and end equally
%
% Fred Hasselman - April 2011
% Contact: me@fredhasselman.com

function [prepped,change] = prep(unprepped,targetlength)

    change=(targetlength-length(unprepped));
    
    %If equal copy
    if change == 0
        
        prepped=unprepped;
        
    %If smaller add zero's equally to begin and end    
    elseif change > 0
 
        %Divide points over begin and end
        if change == 1
            be = 1; en = 0;
        elseif mod(change,2) ~= 0
            be = floor(change/2); en = be+1;
        else
            be = change/2; en = be;
        end
        
        %Pad it!
        prepped=padarray(unprepped,be,'pre');
        prepped=padarray(prepped,en,'post');
            
    %If larger remove datapoints equally from begin and end
    else
  
        %Divide points over begin and end
        if abs(change) == 1
            be = 1; en = 0;
        elseif mod(abs(change),2) ~= 0
            be = (abs(change)+1)/2; en = be;
        else
            be = abs(change)/2; en = be+1;
        end
        
        %Trim it!
        prepped = unprepped(be:length(unprepped)-en);
        
    end
end
    