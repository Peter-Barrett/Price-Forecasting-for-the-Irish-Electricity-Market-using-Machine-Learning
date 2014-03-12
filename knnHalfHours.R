# Author: Peter Barrett
# Price Forecasting for the Irish Electricity Market using Machine Learning
#
# Summary: 
# K-NN half hours forecasting
#

library(pdist)
library(doMC)
library(foreach)
registerDoMC(8)

getPriceForHalfHour <- function(targetHalfHour){
  halfHours = length(knnValidationGenerators[,1])
  t = targetHalfHour
  similarities = list();
  prices = list();
  
  a = foreach(i = 1: halfHours) %dopar% {
    similarities[i] = pdist(t,knnValidationGenerators[i,])@dist[1];
  }
  prices = validation_data.EP2_SMP;
  prices = prices[order(unlist(a))];
  
  return((prices[1] + prices[2] +prices[3])/3); #order prices accoring to lowest similarity
}

pricesForDay <- function(targetHalfHours){
  n=length(targetHalfHours[,1])
  day = list();
  day = foreach(i= 1:n)  %do% {
    if(i%%10 == 0) cat(i," - Half Hours Done\n");
    getPriceForHalfHour(targetHalfHours[i,])
    
  }
  return(day);
}

kNN <- function(halfHour,k){
  sum = 0;
  for(i in 1:k){
    sum = sum + halfHour[i];
  }
  sum/k
}

forecastPrices <- function(timePeriod,neighbours){
  n = length(timePeriod);
  days = list();
  for(i in 1:n){
    
    if(i%%48==24 || i%%48==25){
      days[i] = kNN(timePeriod[[i]],50);
    }else{
      days[i] = kNN(timePeriod[[i]],neighbours);
    }
  }
  days
}

print("Started")
timePar1v2 = pricesForDay(knnTestGenerators[0:1000,]);
print("done 1")
timePar2v2  = pricesForDay(knnTestGenerators[1000:2000,]);
print("done 2")
timePar3v2  = pricesForDay(knnTestGenerators[2000:3000,]);
print("done 3")
timePar4v2  = pricesForDay(knnTestGenerators[3000:4176,]);
print("Finished")


optimalNeighbours = 0;
bestMSE = 10000;
#find the optimal number of neighbours from validation data and use those for test data
for(i in 340:380){
  if(i%%20 == 0) cat(i," - Neighbours Tested Best:", bestMSE, "\n");
  forecastknn1 =forecastPrices(timePar1v5,i);
  forecastknn2 = forecastPrices(timePar2v5,i);
  forecastknn3 =forecastPrices(timePar3v5,i);
  forecastknn4 = forecastPrices(timePar4v5,i);
  
  forecastKnn = c(unlist(forecastknn1),unlist(forecastknn2),unlist(forecastknn3),unlist(forecastknn4))
  
  score = mean( (forecastKnn - test_data.EP2_SMP)^2, na.rm = TRUE);
  if(score < bestMSE){
    bestMSE = score;
    optimalNeighbours = i;
  }
}

print(bestMSE)
print(optimalNeighbours)

forecastknn1 =forecastPrices(timePar1v5,optimalNeighbours);
forecastknn2 = forecastPrices(timePar2v5,optimalNeighbours);
forecastknn3 =forecastPrices(timePar3v5,optimalNeighbours);
forecastknn4 = forecastPrices(timePar4v5,optimalNeighbours);
forecastKnn = c(unlist(forecastknn1),unlist(forecastknn2),unlist(forecastknn3),unlist(forecastknn4));
forecastKnn.MSE =  mean( (forecastKnn - test_data.EP2_SMP)^2, na.rm = TRUE)
forecastKnn.MAE = mean( abs(forecastKnn - test_data.EP2_SMP), na.rm = TRUE)
forecastKnn.summary = summary(forecastKnn);
