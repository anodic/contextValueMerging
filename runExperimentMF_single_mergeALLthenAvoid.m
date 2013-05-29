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

addpath('D:\00xBeds\23-contextValueMerging-RecSys2013\02-data');
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
learningRate = 0.03;
lRateUserBias = 0.003;
lRateItemBias = 0.01;

lRatecontextBias = lRateUserBias;
K = 0.3;
initValue = 0.03;

% the one that works!
% numOfFeatures = 10;
% numOfEpochs = 100;
% learningRate = 0.0001;
% lRateUserBias = 0.00001;
% lRateItemBias = 0.0001;
%
% lRatecontextBias = lRateUserBias;
% K = 0.005;
% initValue = 0.03;


%% Load data
%testSetName = 'newCoMoDaTest2.xlsx';
%trainSetName = 'newCoMoDaTrain2.xlsx';

% testSetName = 'newCoMoDaOnlyContextTest1.xlsx';
% trainSetName = 'newCoMoDaOnlyContextTrain1.xlsx';

% testSetName = 'LDOScontextTEST.xlsx';
% trainSetName = 'LDOScontextTRAINnoLAST.xlsx';

% testSetName = 'LDOScomodaTestOriginal3.xlsx';
% trainSetName = 'LDOScomodaTrainOriginal3.xlsx';
% 
% testSet = xlsread(testSetName);
% trainSet = xlsread(trainSetName);

load valueRelevancyRes.mat;

%% Matrix factorization

% do context?
doContext = 1;
context = 5;

% do random?
doRandom = 1;

% v2.0. identify irrelevant context
irrelCntxVals = resultFuse(context).irrelevant;
mergeMatrix=zeros(cntxCategorySizes(context),cntxCategorySizes(context));
% v2.0. identify merge possibilities
for i = 1: length(irrelCntxVals)
    potentialMerges = find(resultFuse(context).matrix(irrelCntxVals(i),:)==0);
    for pp = 1 : length(potentialMerges)
        mergeMatrix(irrelCntxVals(i),pp)=potentialMerges(pp);
    end
end

if doRandom == 1
    randMergeMatrix = zeros(cntxCategorySizes(context),cntxCategorySizes(context));
    
    
    rPerm = randperm(cntxCategorySizes(context));
    
    randIrrelCntxVals = rPerm(1:length(irrelCntxVals));
    
    randOthers = rPerm(length(irrelCntxVals)+1:end);
    for rr = 1: length(randIrrelCntxVals)
        randOthers=randOthers(randperm(length(randOthers)));
        uniqueMerges = unique(mergeMatrix(irrelCntxVals(rr),:));
        uniqueMerges = uniqueMerges(find(uniqueMerges~=0));
        numOfMerges = length(uniqueMerges);
        tempMerges = randOthers(1:numOfMerges);
        for pp = 1 : length(tempMerges)
            randMergeMatrix(randIrrelCntxVals(rr),pp)= tempMerges(pp);
        end
    end
    mergeMatrix = randMergeMatrix;
end

rmsovi=zeros(1,10);

for fIndex = 1:10
    disp(['fold: ' num2str(fIndex)]);
    
    testSetName = ['LDOScomodaTestOriginal' num2str(fIndex) '.xlsx'];
    
    trainSetName = ['LDOScomodaTrainOriginal' num2str(fIndex) '.xlsx'];
    
    testSet = xlsread(testSetName);
    trainSet = xlsread(trainSetName);
    
    contextUserBiases = 0;
    globalBias = 0;
    userBiases = 0;
    itemBiases = 0;
    
    % calculate biases
    [contextUserBiases,globalBias, userBiases, itemBiases] = calculateBiases_single( trainSet, cntxCategorySizes);
    %[contextUserBiases,globalBias, userBiases, itemBiases] = setupBiases_single( trainSet, cntxCategorySizes);
    % ratingsVector = trainSet(:,3);
    % [cTypeBias,cTypeGlobalBiases ]= calculateGlobalBias( ratingsVector );
    
    % training
    pUF = zeros(max(trainSet(:,1)),numOfFeatures);
    qIF = zeros(max(trainSet(:,2)),numOfFeatures);
    
    
    count2 = 1;
    count21 = 1;
    count47 = 1;
    for f = 1: numOfFeatures
        disp(['feature: ' num2str(f)]);
        
        pUF (:,f) = initValue;
        qIF (:,f) = initValue;
        for e = 1:numOfEpochs
            
            for i = 1:size(trainSet,1)
                contextValues = 0;
                count = 1;
                errors = [];
                userID = trainSet(i,1);
                itemID = trainSet(i,2);
                trueRating = trainSet(i,3);
                contextValue = trainSet(i,3+context);
                if ismember(contextValue,irrelCntxVals)
                    contextValues = unique(mergeMatrix(contextValue,:));
                    contextValues = contextValues(find(contextValues~=0));
                else
                    contextValues = contextValue;
                end
                
                for kk = 1:length(contextValues)
                    
                    if contextValues(kk) == 0 || doContext==0
                        
                        [estimatedRating] = predictScore_single(pUF(userID,:), qIF(itemID,:),...
                            globalBias, userBiases(userID), itemBiases(itemID));
                        
                    else
                        
                        [estimatedRating] = predictScore_single(pUF(userID,:), qIF(itemID,:),...
                            globalBias, contextUserBiases(context,userID,contextValues(kk)), itemBiases(itemID));
                        
                    end
                    
                    estimatedRating= fixRating(estimatedRating);
                    
                    
                    error = trueRating - estimatedRating;
                    
                    
                    
                    tempUF = pUF(userID,f);
                    tempIF = qIF(itemID,f);
                    
                    pUF(userID,f) = tempUF + (error * tempIF - K * tempUF) * learningRate;
                    qIF(itemID,f) = tempIF + (error * tempUF - K * tempIF) * learningRate;
                    
                    userBiases(userID) = userBiases(userID) + lRateUserBias * (error-K*userBiases(userID));
                    itemBiases(itemID) = itemBiases(itemID) + lRateItemBias * (error-K*itemBiases(itemID));
                    
                    if contextValues(kk) ~= 0
                        contextUserBiases(context,userID,contextValues(kk)) = contextUserBiases(context,userID,contextValues(kk))  + lRatecontextBias * (error-K*contextUserBiases(context,userID,contextValues(kk)));
                    end
                    
                    
                end
                
            end
            
            
        end
        
        
    end
    
    
    
    % validating
    for i = 1: size(testSet,1)
        userID = testSet(i,1);
        itemID = testSet(i,2);
        trueRating = testSet(i,3);
        contextValue = testSet(i,3+context);
        
        if contextValue == 0 || doContext==0 || ismember(contextValue, irrelCntxVals)
            
            [estimatedRating] = predictScore_single(pUF(userID,:), qIF(itemID,:),...
                globalBias, userBiases(userID), itemBiases(itemID));
            
        else
            
            [estimatedRating] = predictScore_single(pUF(userID,:), qIF(itemID,:),...
                globalBias, contextUserBiases(context,userID,contextValue), itemBiases(itemID));
            
        end
        
        fixedRating= fixRating(estimatedRating);
        
        %estRatings(i) = fixedRating;
        
        ratingsDifferences(i) = trueRating - fixedRating;
        
        
    end
    
    RMSE = sum(ratingsDifferences.^2);
    RMSE = sqrt(RMSE/size(testSet,1));
    
    RMSE
    
    rmsovi(fIndex)=RMSE;
    
end

rmsovi



%  figure, plot(ubgraf)
%  title '220 ratings - user bias'
%   figure, plot(ibgraf)
%  title '23 ratings - item bias'
%
%  figure, plot(pgraf)
%  title '220 ratings - user feature'
%  figure, plot(qgraf)
%  title '23 ratings - item feature'
