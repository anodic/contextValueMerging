
addpath('D:\00xBeds\23-contextValueMerging-RecSys2013\04-results');

data = xlsread('context7.xlsx');

disp('end emotion')
disp('*************************')

[pMerge,hMerge] = signrank(data(:,1),data(:,2));
[pRMerge,hRMerge] = signrank(data(:,1),data(:,3));
disp(['p-val for classic vs. merge is: ' num2str(pMerge)])
disp(['p-val for classic vs. rMerge is: ' num2str(pRMerge)])

figure, boxplot([data(:,1)-data(:,2) data(:,1)-data(:,3)])
title('end emotion','FontSize',16)
refline(0,0)
set(gca,'XTick',[1 2])
set(gca,'XTickLabel',{'basic-merge' 'basic-randMerge'},'FontSize',16)
ylabel('RMSE difference', 'FontSize',16);
h = findobj(gca,'Tag','Box');

patch(get(h(1),'XData'),get(h(1),'YData'),'r','FaceAlpha',.5);

patch(get(h(2),'XData'),get(h(2),'YData'),'g','FaceAlpha',.5);
disp('*************************')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = xlsread('context9.xlsx');

disp('mood')
disp('*************************')

[pMerge,hMerge] = signrank(data(:,1),data(:,2));
[pRMerge,hRMerge] = signrank(data(:,1),data(:,3));
disp(['p-val for classic vs. merge is: ' num2str(pMerge)])
disp(['p-val for classic vs. rMerge is: ' num2str(pRMerge)])


figure, boxplot([data(:,1)-data(:,2) data(:,1)-data(:,3)])
title('mood','FontSize',16)
refline(0,0)
set(gca,'XTick',[1 2])
set(gca,'XTickLabel',{'basic-merge' 'basic-randMerge'},'FontSize',16)
ylabel('RMSE difference', 'FontSize',16);
h = findobj(gca,'Tag','Box');

patch(get(h(1),'XData'),get(h(1),'YData'),'r','FaceAlpha',.5);

patch(get(h(2),'XData'),get(h(2),'YData'),'g','FaceAlpha',.5);
disp('*************************')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = xlsread('context8.xlsx');

disp('dominant emotion ')
disp('*************************')

[pMerge,hMerge] = signrank(data(:,1),data(:,2));
[pRMerge,hRMerge] = signrank(data(:,1),data(:,3));
disp(['p-val for classic vs. merge is: ' num2str(pMerge)])
disp(['p-val for classic vs. rMerge is: ' num2str(pRMerge)])

figure, boxplot([data(:,1)-data(:,2) data(:,1)-data(:,3)])
title('dominant emotion','FontSize',16)
refline(0,0)
set(gca,'XTick',[1 2])
set(gca,'XTickLabel',{'basic-merge' 'basic-randMerge'},'FontSize',16)
ylabel('RMSE difference', 'FontSize',16);
h = findobj(gca,'Tag','Box');

patch(get(h(1),'XData'),get(h(1),'YData'),'g','FaceAlpha',.5);

patch(get(h(2),'XData'),get(h(2),'YData'),'g','FaceAlpha',.5);
disp('*************************')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = xlsread('context6.xlsx');

disp('social')
disp('*************************')

[pMerge,hMerge] = signrank(data(:,1),data(:,2));
[pRMerge,hRMerge] = signrank(data(:,1),data(:,3));
disp(['p-val for classic vs. merge is: ' num2str(pMerge)])
disp(['p-val for classic vs. rMerge is: ' num2str(pRMerge)])

figure, boxplot([data(:,1)-data(:,2) data(:,1)-data(:,3)])
title('social','FontSize',16)
refline(0,0)
set(gca,'XTick',[1 2])
set(gca,'XTickLabel',{'basic-merge' 'basic-randMerge'},'FontSize',16)
ylabel('RMSE difference', 'FontSize',16);
h = findobj(gca,'Tag','Box');

patch(get(h(1),'XData'),get(h(1),'YData'),'r','FaceAlpha',.5);

patch(get(h(2),'XData'),get(h(2),'YData'),'g','FaceAlpha',.5);
disp('*************************')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = xlsread('context5.xlsx');

disp('weather')
disp('*************************')

[pMerge,hMerge] = signrank(data(:,1),data(:,2));
[pRMerge,hRMerge] = signrank(data(:,1),data(:,3));
disp(['p-val for classic vs. merge is: ' num2str(pMerge)])
disp(['p-val for classic vs. rMerge is: ' num2str(pRMerge)])

figure, boxplot([data(:,1)-data(:,2) data(:,1)-data(:,3)])
title('weather','FontSize',16)
refline(0,0)
set(gca,'XTick',[1 2])
set(gca,'XTickLabel',{'basic-merge' 'basic-randMerge'},'FontSize',16)
ylabel('RMSE difference', 'FontSize',16);
h = findobj(gca,'Tag','Box');

patch(get(h(1),'XData'),get(h(1),'YData'),'g','FaceAlpha',.5);

patch(get(h(2),'XData'),get(h(2),'YData'),'g','FaceAlpha',.5);
disp('*************************')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = xlsread('context3.xlsx');

disp('season')
disp('*************************')

[pMerge,hMerge] = signrank(data(:,1),data(:,2));
[pRMerge,hRMerge] = signrank(data(:,1),data(:,3));
disp(['p-val for classic vs. merge is: ' num2str(pMerge)])
disp(['p-val for classic vs. rMerge is: ' num2str(pRMerge)])


figure, boxplot([data(:,1)-data(:,2) data(:,1)-data(:,3)])
title('season','FontSize',16)
refline(0,0)
set(gca,'XTick',[1 2])
set(gca,'XTickLabel',{'basic-merge' 'basic-randMerge'},'FontSize',16)
ylabel('RMSE difference', 'FontSize',16);
h = findobj(gca,'Tag','Box');

patch(get(h(1),'XData'),get(h(1),'YData'),'r','FaceAlpha',.5);

patch(get(h(2),'XData'),get(h(2),'YData'),'r','FaceAlpha',.5);
disp('*************************')






% 
% 
% 
% 
% combinationNum = 1;
% boxplotNum =1;
% boxplotData = zeros(size(data,1),1);
% basicVScontext = zeros(10,12);
% avgVScontext = zeros(10,12);
% 
% diffPvalsFormZero = zeros(8,4);
% 
% for k = 1:12
%     basicVScontext(:,k) = data(:,basicMF)-data(:,k);
% end
% figure, boxplot(basicVScontext);
% h = findobj(gca,'Tag','Box');
% 
% for c = 1: length(relevantCntxt)
%     currentBox = 13 - relevantCntxt(c);
%     patch(get(h(currentBox),'XData'),get(h(currentBox),'YData'),'g','FaceAlpha',.5);
% end
% 
% 
% 
% 
% 
% set(gca,'XTick',[1 2 3 4 5 6 7 8 9 10 11 12])
% set(gca,'XTickLabel',{'t' 'day' 'sea' 'loc' 'wea' 'soc' 'end' 'dom' 'md' 'phy' 'dec' 'int'})
% set(gca,'FontSize',12)
% 
% 
% 
% 
% 
% 
% refline(0,0)
% 
% %xlabel('Context variables', 'FontSize',18);
% ylabel('RMSE difference', 'FontSize',16);
% 
% for kk = 1:12
%     avgVScontext(:,kk) = data(:,AVG)-data(:,kk);
% end
% 
% figure, boxplot(avgVScontext);
% set(gca,'XTick',[1 2 3 4 5 6 7 8 9 10 11 12])
% set(gca,'XTickLabel',{'t' 'day' 'sea' 'loc' 'wea' 'soc' 'end' 'dom' 'md' 'phy' 'dec' 'int'})
% set(gca,'FontSize',12)
% 
% refline(0,0)
% 
% %xlabel('Context variables', 'FontSize',18);
% ylabel('RMSE difference', 'FontSize',16);
% 
% 
% for i = 1:length(irrelevantCntxt)
%    for j=1:length(relevantCntxt) 
%        
%     result(combinationNum).combination = [num2str(irrelevantCntxt(i)) '-' num2str(relevantCntxt(j))]
%     result(combinationNum).diffs = data(:,irrelevantCntxt(i)) - data(:,relevantCntxt(j));
%     result(combinationNum).pValFromZero = signtest(result(combinationNum).diffs)
%     diffPvalsFormZero(j,i) = result(combinationNum).pValFromZero;
%     
%     
%     
%     boxplotData(:,boxplotNum) = result(combinationNum).diffs;
%     boxplotNum = boxplotNum+1;
%     
%     
%     
%     combinationNum = combinationNum + 1;
%    end    
%    figure, boxplot(boxplotData);
%    set(gca,'XTick',[1 2 3 4 5 6 7 8])
% set(gca,'XTickLabel',{'day' 'loc' 'end' 'dom' 'md' 'phy' 'dec' 'int'})
% set(gca,'FontSize',15)
%    
%    
%    refline(0,0)
%    %set(gca,'FontSize',14);
%    %xlabel('Relevant context variables', 'FontSize',18);
%    ylabel('RMSE difference', 'FontSize',18);
% 
%    boxplotNum = 1;
%    boxplotData = zeros(size(data,1),1);
% end
% 
% stoping=3;