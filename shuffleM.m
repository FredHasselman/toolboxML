%% Fred's UTILS: Randomly shuffle data
%
% Usage: shuffled = shuffle(Data)
%
% - Data - A single column of data points
%
% Fred Hasselman - May 2008
% Contact: me@fredhasselman.com

function [shuffledM] = shuffleM(Data,times)

[r,column]=size(Data);

if column > 1
 disp('More than 1 column are detected.');
 disp('Default behaviour is to shuffle all elements in the matrix.');
 disp('Use shuffle to shuffle.m individual columns in a matrix.');
end

if ~exist('times','var')
 times=1;
end

shuffled = zeros(r*column,1);

rng('shuffle');


shuffled=Data(:);

for t=1:times
 
 [~,myorder]=sort(rand(1,length(shuffled)));
 shuffled=shuffled(myorder);
 
end

shuffledM=reshape(shuffled,r,column);
