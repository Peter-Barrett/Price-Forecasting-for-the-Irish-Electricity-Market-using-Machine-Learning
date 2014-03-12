# Author: Peter Barrett
# Price Forecasting for the Irish Electricity Market using Machine Learning
#
# Summary: 
# Neural Network Creation
#

library("monmlp")
traininginput <- cbind(c(data2010.EA_LOAD,validation_data.EA_LOAD),c(data2010.EA_WIND,validation_data.EA_WIND),c(data2010.SHADOW,validation_data.SHADOW));#   as.data.frame(runif(50, min=0, max=100))
trainingoutput <- c(data2010.EP2_SMP,validation_data.EP2_SMP);#sqrt(traininginput)

#Column bind the data into one variable
trainingdata <- cbind(traininginput,trainingoutput)
colnames(trainingdata) <- c("Load","Wind","Shadow","Output")

#Train the neural network
#Here I tried a number of different node combinations
#net.forecast <- neuralnet(Output~Load+Wind+Shadow,trainingdata, hidden=5, threshold=0.001,algorithm="rprop+")
#net.forecast2 <- monmlp.fit(traininginput,as.matrix(trainingoutput),hidden1=10,hidden2=3); #936.1483 
#net.forecast2 <- monmlp.fit(traininginput,as.matrix(trainingoutput),hidden1=5,hidden2=3);#885.7303
#net.forecast2 <- monmlp.fit(traininginput,as.matrix(trainingoutput),hidden1=5,hidden2=5); #875.11
#net.forecast2 <- monmlp.fit(traininginput,as.matrix(trainingoutput),hidden1=3,hidden2=2); #857.4007938
net.forecast2 <- monmlp.fit(traininginput,as.matrix(trainingoutput),hidden1=3,hidden2=2)

#Test the neural network on some training data
testdata <- cbind(test_data.EA_LOAD,test_data.EA_WIND,test_data.SHADOW) 
colnames(testdata) <- c("Load","Wind","Shadow")
#net.results <- compute(net.forecast, testdata) #Run them through the neural network
net.results2 = monmlp.predict(testdata,net.forecast2)
print(mean( (net.results2 - test_data.EP2_SMP)^2, na.rm = TRUE));
print( mean( abs(net.results2 - test_data.EP2_SMP), na.rm = TRUE);)
