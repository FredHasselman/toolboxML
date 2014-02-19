%% Fred's Toolbox: Get a clean workspace, command window and close all figures
% 
% Use: omo
%
% Like the detergent,
% This will clean and close everything through and through, 
% No warnings! ...use wisely.   
% 
% Fred Hasselman - Februari 2011
% Contact: me@fredhasselman.com

function omo
    
    wh = evalin('caller','who');
    
    %Check workspace variables to clear
    if isempty(wh)
        disp('  There is nothing to clean in the workspace!')
    else
        for i=1:length(wh)
            evalin('caller',['clear ' wh{i}]);
        end
    end
    
    %Just to be sure
    clear all
    clear global
    clear variables
    close all
    clc
end