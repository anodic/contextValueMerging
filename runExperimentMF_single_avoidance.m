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

numOfFeatures = 1;
numOfEpochs = 200;
learningRate = 0.03;
lRateUserBias = 0.003;
lRateItemBias = 0.01;

lRatecontextBias = lRateUserBias;
K = 0.3;
initValue = 0.03;

% numOfFeatures = 10;
% numOfEpochs = 300;
% learningRate = 0.007;
% lRateItemBias = 0.007;
% lRateUserBias = 0.007;
% lRatecontextBias = 0.001;
% K = 0.05;
% initValue = 0.03;


%% Load data
testSetName = 'newCoMoDaTest2.xlsx';
trainSetName = 'newCoMoDaTrain2.xlsx';

% testSetName = 'LDOScontextTEST.xlsx';
% trainSetName = 'LDOScontextTRAINnoLAST.xlsx';

testSet = xlsread(testSetName);
trainSet = xlsread(trainSetName);


%% Matrix factorization

% do context
doContext = 1; 
context = 8;


% calculate biases
[contextUserBiases,globalBias, userBiases, itemBiases] = calculateBiases_single( trainSet, cntxCategorySizes);
%[contextUserBiases,globalBias, userBiases, itemBiases] = setupBiases_single( trainSet, cntxCategorySizes);

% training
pUF = zeros(max(trainSet(:,1)),numOfFeatures);
qIF = zeros(max(trainSet(:,2)),numOfFeatures);



count2 = 1;
count21 = 1;
count47 = 1;

load valueRelevancyRes.mat;



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
            
%             if itemID == 2205
%                 ante = 4
%             end
            
           % use uncontextualize bias if missing value, doContext == 0, irrelevant value 
            if contextValue == 0 || doContext==0 || ismember(contextValue, resultFuse(context).irrelevant )
                
                [estimatedRating] = predictScore_single(pUF(userID,:), qIF(itemID,:),...
                    globalBias, userBiases(userID), itemBiases(itemID));
                
            else
                
                [estimatedRating] = predictScore_single(pUF(userID,:), qIF(itemID,:),...
                    globalBias, contextUserBiases(context,userID,contextValue), itemBiases(itemID));
                
            end
            
            %fixedRating= fixRating(estimatedRating);
            
            error = trueRating - estimatedRating;
            
                          
            errors(count) = error;
            count = count+1;
            
            
            tempUF = pUF(userID,f);
            tempIF = qIF(itemID,f);
                        
            pUF(userID,f) = tempUF + (error * tempIF - K * tempUF) * learningRate;
            qIF(itemID,f) = tempIF + (error * tempUF - K * tempIF) * learningRate;
            
            
            userBiases(userID) = userBiases(userID) + lRateUserBias * (error-K*userBiases(userID));
            itemBiases(itemID) = itemBiases(itemID) + lRateItemBias * (error-K*itemBiases(itemID));
            if userID == 21
                user21Biases(count21) = userBiases(21);
                count21 = count21+1;
            end
            if itemID == 47
                item47Biases(count47) = itemBiases(47);
                
                count47 = count47+1;
            end
            
            
            
            if contextValue ~= 0
                contextUserBiases(context,userID,contextValue) = contextUserBiases(context,userID,contextValue)  + lRatecontextBias * (error-K*contextUserBiases(context,userID,contextValue));
               
            end
            
            
                        
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
figure, plot(user21Biases)
figure, plot(item47Biases)
% validating
for i = 1: size(testSet,1)
    userID = testSet(i,1);
    itemID = testSet(i,2);
    trueRating = testSet(i,3);
    contextValue = testSet(i,3+context);
    
    if contextValue == 0 || doContext==0 || ismember(contextValue, resultFuse(context).irrelevant )
        
        [estimatedRating] = predictScore_single(pUF(userID,:), qIF(itemID,:),...
            globalBias, userBiases(userID), itemBiases(itemID));
        
    else
        
        [estimatedRating] = predictScore_single(pUF(userID,:), qIF(itemID,:),...
            globalBias, contextUserBiases(context,userID,contextValue), itemBiases(itemID));
        
    end
    
    fixedRating= fixRating(estimatedRating);
            
    
    ratingsDifferences(i) = trueRating - fixedRating;
    
    
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























