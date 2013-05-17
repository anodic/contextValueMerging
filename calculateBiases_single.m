function [contextUserBiases, globalBias, userBiases, itemBiases] = calculateBiases( trainSet, cntxCategorySizes )

userBiases = zeros(1,max(trainSet(:,1)));
itemBiases = zeros(1,max(trainSet(:,2)));
contextUserBiases = zeros(12,max(trainSet(:,1)),7);

% global bias
globalBias = mean(trainSet(:,3));

% users' biases
for usr = min(trainSet(:,1)) : max(trainSet(:,1))
    [userIndexes, dummy] = find(trainSet(:,1)==usr);
    if(isempty(userIndexes))
        continue;
    end
    sumOfRatings = sum(trainSet(userIndexes,3));
    userBiases(usr) = sumOfRatings/length(userIndexes);
end

userBiases = userBiases - globalBias;

% items' biases
for itm = min(trainSet(:,2)) : max(trainSet(:,2))
    [itemIndexes, dummy] = find(trainSet(:,2)==itm);
    if(isempty(itemIndexes))
        continue;
    end
    sumOfRatings = sum(trainSet(itemIndexes,3));
    itemBiases(itm) = sumOfRatings/length(itemIndexes);
end

itemBiases = itemBiases - globalBias;

% calculate contextualized users biases

for contextIndex = 1 : 12
    for usrIndex = min(trainSet(:,1)) : max(trainSet(:,1))
        for cntxValueIndex = 1 : cntxCategorySizes(contextIndex)
            [hitIndexes, dummy] = find(trainSet(:,1)==usrIndex & trainSet(:,3+contextIndex)==cntxValueIndex );
            if(isempty(hitIndexes))
                contextUserBiases(contextIndex,usrIndex,cntxValueIndex)=userBiases(usrIndex)+globalBias;
            else
                sumOfRatings = sum(trainSet(hitIndexes,3));
                contextUserBiases(contextIndex,usrIndex,cntxValueIndex) = sumOfRatings/length(hitIndexes);
            end
            
            
        end
    end
end

contextUserBiases = contextUserBiases- globalBias;


end