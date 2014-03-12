# Author: Peter Barrett
# Price Forecasting for the Irish Electricity Market using Machine Learning
#
# Summary: 
# ARIMA forecasting
#

library(forecast)
library(zoo)
#carry out ARIMA analysis to determine best model

#difference SMP to make it stationary
model.SMP_diff1 = diff(data2010.EP2_SMP,1);
mean(data2010.EP2_SMP);
par(mfrow=c(1,1));
plot(model.SMP_diff1);
model.SMP_acf = acf(model.SMP_diff1); 
model.SMP_pacf = pacf(model.SMP_diff1); 

#suggests q = 4
#suggests p = 2
#difference of 1 required to get stationary

model.fit1 = Arima(data2010.EP2_SMP,order=c(3,1,3),xreg=cbind(data2010.EP2_LOAD,data2010.EA_WIND));
model.fit2 = Arima(data2010.EP2_SMP,order=c(3,1,3),xreg=cbind(data2010.EP2_LOAD,data2010.EA_WIND,data2010.SHADOW))
model.forecast2 = forecast(model.fit2,xreg=cbind(data2010.EA_LOAD,data2010.EA_WIND,data2010.SHADOW));
plot(model.forecast2)
lines(data2010.EP2_SMP[0:384],col=3)

#mse = mean( (c(model.forecast2$x,model.forecast2$fitted) - data2010.EP2_SMP[0:384])^2, na.rm = TRUE)
#mae = mean( abs(c(model.forecast2$x,model.forecast2$fitted) - data2010.EP2_SMP[0:384]), na.rm = TRUE)


#training set
model.fit1 = Arima(validation_data.EP2_SMP,order=c(3,1,3),xreg=cbind(validation_data.EP2_LOAD,validation_data.EA_WIND))
model.forecast1 =  forecast(model.fit1,xreg=cbind(test_data.EA_LOAD,test_data.EA_WIND));
model.mse1 = mean( (model.forecast1$mean - test_data.EP2_SMP)^2, na.rm = TRUE);
model.mae1 = mean( abs(model.forecast1$mean - test_data.EP2_SMP), na.rm = TRUE);

model.fit2 = Arima(validation_data.EP2_SMP,order=c(3,1,3),xreg=cbind(validation_data.EP2_LOAD,validation_data.EA_WIND,validation_data.SHADOW))
model.forecast2 =  forecast(model.fit2,xreg=cbind(test_data.EA_LOAD,test_data.EA_WIND,test_data.SHADOW));
model.mse2 = mean( (model.forecast2$mean - test_data.EP2_SMP)^2, na.rm = TRUE);
model.mae2 = mean( abs(model.forecast2$mean - test_data.EP2_SMP), na.rm = TRUE);

validation.model = Arima(validation_data.EP2_SMP,order=c(4,1,2),xreg=cbind(diff(validation_data.EP2_LOAD,2),validation_data.EA_WIND,validation_data.SHADOW));
validation.forecast = forecast(validation.model,xreg=cbind(diff(test_data.EA_LOAD,2),test_data.EA_WIND,test_data.SHADOW));
validation.mse = mean( (validation.forecast$fitted - validation_data.EP2_SMP)^2, na.rm = TRUE)
validation.mae = mean( abs(validation.forecast$fitted - validation_data.EP2_SMP), na.rm = TRUE)

plot(validation.forecast)
lines(test_data.EP2_SMP, col = 2)

results.mse = mean( (validation.forecast$mean - test_data.EP2_SMP)^2, na.rm = TRUE);
results.mae = mean( abs(validation.forecast$mean - test_data.EP2_SMP), na.rm = TRUE);