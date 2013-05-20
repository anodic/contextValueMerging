function [ fixedRating ] = fixRating( estimatedScore )
%FIXRATING Summary of this function goes here
%   Detailed explanation goes here

if estimatedScore<1
    fixedRating=1;
elseif estimatedScore>5
    fixedRating =5;
else
    fixedRating = estimatedScore;
end

end

