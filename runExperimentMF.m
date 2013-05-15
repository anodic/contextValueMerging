% @brief Matrix factorization
%
% @author: Ante Odiæ
%


%% Settings
% <set>
%absoluteRootPath = 'D:\00xBeds\04-MatrixFactorizationMATLABTools';
%dataPath = '02-Data\LDOS';
%toolsPath = '03-Tools';
% </set>

%global testSet;


%addpath(fullfile(absoluteRootPath, dataPath));
%addpath(fullfile(absoluteRootPath, toolsPath));
clear all



varsIds = cell(1, 20);
varsIds{1} = 'UserID'; varsIds{2} = 'ItemID'; varsIds{3} = 'Rating';
varsIds{4} = 'Age'; varsIds{5} = 'Sex'; varsIds{6} = 'City';
varsIds{7} = 'Country'; varsIds{8} = 'Reliability'; varsIds{9} = 'Time';
varsIds{10} = 'Daytype'; varsIds{11} = 'Season'; varsIds{12} = 'Location';
varsIds{13} = 'Weather'; varsIds{14} = 'Social'; varsIds{15} = 'EndEmotion';
varsIds{16} = 'DominantEmotion'; varsIds{17} = 'Mood'; varsIds{18} = 'Physical';
varsIds{19} = 'Decision'; varsIds{20} = 'Interaction';
% Ante: 9 - 20 so kontekst - potentialy.

cntxCategorySizes  = [4,3,4,3,5,7,7,7,3,2,2,2];

numOfFeatures = 10;
numOfEpochs = 200;
learningRate = 0.007;
lRateItemBias = 0.01;
lRateUserBias = 0.0001;
K = 0.0005;
initValue = 0.03;


%% Load data
testSetName = 'LDOScontextTEST.xlsx';
trainSetName = 'LDOScontextTRAINnoLAST.xlsx';

testSet = xlsread(testSetName);
trainSet = xlsread(trainSetName);


%% Matrix factorization

% do context
doContext = 1; 

% calculate biases
[contextUserBiases,globalBias, userBiases, itemBiases] = calculateBiases( trainSet, cntxCategorySizes);

% training
pUF = zeros(max(trainSet(:,1)),numOfFeatures);
qIF = zeros(max(trainSet(:,2)),numOfFeatures);

context = 7;

count2 = 1;
for f = 1: numOfFeatures
   
    pUF (:,f) = initValue;
    qIF (:,f) = initValue;
    for e = 1:numOfEpochs
                
        for i = 1:size(trainSet,1)
            count = 1;
            errors = [];
            userID = trainSet(i,1);
            itemID = trainSet(i,2);
            trueRating = trainSet(i,3);
            contextValue = trainSet(i,3+context);
            
            if contextValue == 0 || doContext==0
                
                [estimatedRating] = predictScore(pUF(userID,:), qIF(itemID,:),...
                    globalBias, userBiases(userID), itemBiases(itemID));
                
            else
                
                [estimatedRating] = predictScore(pUF(userID,:), qIF(itemID,:),...
                    globalBias, contextUserBiases(context,userID,contextValue), itemBiases(itemID));
                
            end
            error = trueRating - estimatedRating;
            
                          
            errors(count) = error;
            count = count+1;
            
            
            tempUF = pUF(userID,f);
            tempIF = qIF(itemID,f);
                        
            pUF(userID,f) = tempUF + (error * tempIF - K * tempUF) * learningRate;
            qIF(itemID,f) = tempIF + (error * tempUF - K * tempIF) * learningRate;
            
                        
        end
        errors = errors.^2;
        overallError = sum(errors)/length(errors);
        overallErrors(count2) = overallError;
        count2 = count2+1;
        if count2 == 1000
            ante = 4;
        end
        
    end
    
    
end


plot(overallErrors)


% validating
for i = 1: size(testSet,1)
    userID = testSet(i,1);
    itemID = testSet(i,2);
    contextValue = trainSet(i,3+context);
    
    if contextValue == 0 || doContext==0
        
        [estimatedRating] = predictScore(pUF(userID,:), qIF(itemID,:),...
            globalBias, userBiases(userID), itemBiases(itemID));
        
    else
        
        [estimatedRating] = predictScore(pUF(userID,:), qIF(itemID,:),...
            globalBias, contextUserBiases(context,userID,contextValue), itemBiases(itemID));
        
    end
    
    ratingsDifferences(i) = trueRating - estimatedRating;
    
    
end

RMSE = sum(ratingsDifferences.^2);
RMSE = sqrt(RMSE/size(testSet,1));

RMSE



%  figure, plot(ubgraf)
%  title '220 ratings - user bias'
%   figure, plot(ibgraf)
%  title '23 ratings - item bias'
%
%  figure, plot(pgraf)
%  title '220 ratings - user feature'
%  figure, plot(qgraf)
%  title '23 ratings - item feature'























