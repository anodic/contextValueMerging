function [estimatedScore] = predictScore_single(p,q, globalBias, userBias, itemBias)

estimatedScore = globalBias + userBias + itemBias + p*q';

% if estimatedScore<1
%     estimatedScore=1;
% elseif estimatedScore>5
%     estimatedScore =5;
% end


end