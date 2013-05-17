function [estimatedScore] = predictScore(p,q, globalBias, userBias, itemBias,contextBiases)

estimatedScore = globalBias + userBias + itemBias + p*q' + sum(contextBiases);

% if estimatedScore<1
%     estimatedScore=1;
% elseif estimatedScore>5
%     estimatedScore =5;
% end
% 

end