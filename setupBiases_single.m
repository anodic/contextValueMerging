function [contextUserBiases, globalBias, userBiases, itemBiases] = setupBiases_single( trainSet, cntxCategorySizes )

userBiases = zeros(1,max(trainSet(:,1)));
itemBiases = zeros(1,max(trainSet(:,2)));
contextUserBiases = zeros(12,max(trainSet(:,1)),7);

% global bias
globalBias = mean(trainSet(:,3));

% users' biases
for usr = min(trainSet(:,1)) : max(trainSet(:,1))
    userBiases(usr) = 0.03;
end

%userBiases = userBiases - globalBias;

% items' biases
for itm = min(trainSet(:,2)) : max(trainSet(:,2))
    itemBiases(itm) = 0.03;
end

%itemBiases = itemBiases - globalBias;

% calculate contextualized users biases

for contextIndex = 1 : 12
    for usrIndex = min(trainSet(:,1)) : max(trainSet(:,1))
        for cntxValueIndex = 1 : cntxCategorySizes(contextIndex)
            [hitIndexes, dummy] = find(trainSet(:,1)==usrIndex & trainSet(:,3+contextIndex)==cntxValueIndex );
            if(isempty(hitIndexes))
                contextUserBiases(contextIndex,usrIndex,cntxValueIndex)=userBiases(usrIndex);
            else
                contextUserBiases(contextIndex,usrIndex,cntxValueIndex) = 0.03;
            end
            
            
        end
    end
end

%contextUserBiases = contextUserBiases- globalBias;


end