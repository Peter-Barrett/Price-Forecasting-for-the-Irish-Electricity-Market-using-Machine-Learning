# Author: Peter Barrett
# Price Forecasting for the Irish Electricity Market using Machine Learning
#
# Summary: 
# K-NN days forecasting
#

library(pdist)
library(doMC)
library(foreach)
registerDoMC(8) # set to how many processors you have available

splitDaysForKnn <-  function(data,priceData){
  days <- list();
  days.prices = list();
  i = 1;
  j = 1;
  while(i< length(data[,1])){
    prices =  priceData[i:(i+47)];
    days[[j]] <- data[i:(i+47),];
    names(days[[j]]) <- names(data)
    days.prices[[j]] <- prices;
    i = i+48;
    j = j+1;
  }
  return(list("days" = days, "prices" = days.prices));
}

computeWithWeightsSimilarity <- function(dayOne,dayTwo){
  #loop through each row in the day computing similarity
   w = c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1.5,1.6,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
  
  s = foreach(i=1:48,.combine='+',.inorder=FALSE) %do%{
    #compute similarity between each row
    ((pdist(dayOne[i,],dayTwo[i,])@dist[1]) *w[i]);
  }
  
  return (s/sum(w))
}

computeSimilarity <- function(dayOne,dayTwo){
  #loop through each row in the day computing similarity
  
  s = foreach(i=1:48,.combine='+',.inorder=FALSE) %do%{
    #compute similarity between each row
    (pdist(dayOne[i,],dayTwo[i,])@dist[1]);
  }
  
  return (s/48
}

findSimilarDays <- function(goalDay, days){
  total = length(days);
  similarDays = foreach(i = 1:total,.combine='c') %dopar%{
    similarity = computeSimilarity(goalDay,days[[i]]);
  }
  return(similarDays);
}


priceForDay <- function(similarDays,prices,k){
  prices = prices[order(similarDays)];
  average = prices[[1]];
  for(i in 2:k){
    average = cbind(average,prices[[i]]); 
  }
  rowMeans(average)
}

getPrices <- function(days,prices,k){
  prices = foreach(i=1:length(days)) %dopar%{
    priceForDay(days[[i]],prices,k);
  }
}

findSimilarDaysForGroup <-function(testDays,knnData){
  numberOfDays = length(testDays);
  prices = list();
  
  allSimilarDays = foreach(i=1:numberOfDays) %dopar%{
    findSimilarDays(testDays[[i]],knnData);
  }
  allSimilarDays
}

#load days
knnData2010.days <- splitDaysForKnn(knnData2010.EP2,data2010.EP2_SMP);
knnData2010.EADays <- splitDaysForKnn(knnData2010.EA,data2010.EA_SMP);
knnData2011.days <- splitDaysForKnn(knnData2011.EP2,data2011.EP2_SMP);
knnData2011.EADays <- splitDaysForKnn(knnData2011.EA,data2011.EA_SMP);
knnValidationData <- splitDaysForKnn(knnValidationGenerators,data2011.EP2_SMP);
knnTestData <- splitDaysForKnn(knnTestGenerators,data2011.EA_SMP);


#Testing

knnData = splitDaysForKnn(knnData2010.EP2,data2010.EP2_SMP);
tempData = knnData;
tempData.validation = splitDaysForKnn(knnValidationGenerators,validation_data.EP2_SMP);
knnData[[1]] = c(tempData[[1]],tempData.validation[[1]]);
knnData[[2]] = c(tempData[[2]],tempData.validation[[2]]);
knnTestData = splitDaysForKnn(knnTestGenerators,test_data.EP2_SMP);

print("Started")
test_1_newW <- findSimilarDaysForGroup(knnTestData[[1]][0:20],knnData[[1]]);
print("Done 1")
test_2_newW <- findSimilarDaysForGroup(knnTestData[[1]][21:40],knnData[[1]]);
print("Done 2")
test_3_newW <- findSimilarDaysForGroup(knnTestData[[1]][41:60],knnData[[1]]);
print("Done 3")
test_4_newW <- findSimilarDaysForGroup(knnTestData[[1]][61:80],knnData[[1]]);
print("Done 4")
test_5_newW <- findSimilarDaysForGroup(knnTestData[[1]][81:87],knnData[[1]]);
print("Done 5")
## organising data for knn


optimalNeighbours = 0;
bestMAE = 10000;
#find the optimal number of neighbours for validation data and use that number for test data
#with the current set-up this would run for all test data
for(i in 1:448){
  if(i%%20 == 0) cat(i," - Neighbours Tested Best:", bestMAE, "\n");
  test_1_prices = getPrices(test_1,knnData[[2]],i)
  test_2_prices = getPrices(test_2,knnData[[2]],i)
  test_3_prices = getPrices(test_3,knnData[[2]],i)
  test_4_prices = getPrices(test_4,knnData[[2]],i)
  test_5_prices = getPrices(test_5,knnData[[2]],i)
  test_knn_prices = c(unlist(test_1_prices),unlist(test_2_prices),unlist(test_3_prices),unlist(test_4_prices),unlist(test_5_prices));
  score = mean( abs(test_knn_prices - test_data.EP2_SMP), na.rm = TRUE)
  
  if(score < bestMAE){
    bestMAE = score;
    bestPricesMAE = test_knn_prices;
    optimalNeighbours = i;
  }
}
print(bestMAE)
print(optimalNeighbours)
plot(bestPrices)

