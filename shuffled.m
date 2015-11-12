%% Fred's UTILS: Randomly shuffle data
%
% Usage: shuffled = shuffle(Data)
%
% - Data - A single column of data points
%
% Fred Hasselman - May 2008
% Contact: me@fredhasselman.com

function [shuffled] = shuffle(Data,times)

[r,column]=size(Data);

if column > 1
 disp('More than 1 column are detected.');
 disp('Default behaviour is to shuffle each column seperately.');
 disp('Use shuffleM.m to shuffle all the elements in a matrix.');
end

if ~exist('times','var')
 times=1;
end

shuffled = zeros(r,column);

%rng('shuffle');


for c=1:column
 
 shuffled(:,c)=Data(:,c);
 
 for t=1:times
  
  [~,myorder]=sort(rand(1,length(shuffled(:,c))));
  shuffled(:,c)=shuffled(myorder);
  
 end
end
