# Author: Peter Barrett
# Price Forecasting for the Irish Electricity Market using Machine Learning
#
# Summary: 
# Script for loading available data for use in models
#
#setwd("set directory to where the data is")
data2010 <- read.csv("data/SEMO-EP2-and-EA-2010-half-hourly-Eirgrid-SEMO-wind-Eirgridoutages-SEMOgenbids-avgsmpprevyears.csv");
data2011 <- read.csv("data/SEMO-EP2-and-EA-2011-half-hourly-Eirgrid-SEMO-wind-Eirgridoutages-SEMOgenbids-avgsmpprevyears.csv");
validation_data <- read.csv("data/Validation_Data.csv");
test_data <- read.csv("data/test_data.csv");

knnData2010.EP2 <- read.csv("data/msq.ep2.2010.features.matrix.csv");
knnData2010.EA <- read.csv("data/msq.ea.2010.features.matrix.csv");
knnData2011.EP2 <- read.csv("data/msq.ep2.2011.features.matrix.csv");
knnData2011.EA <- read.csv("data/msq.ea.2011.features.matrix.csv");
knnValidationGenerators <- read.csv("data/knn_data/validation.csv");
knnTestGenerators <- read.csv("data/knn_data/test_ea.csv");

validation_data.EP2_SMP = ts(validation_data[["SMP"]],start = 2010,frequency=17424); #True System Marginal Price
validation_data.EA_SMP = ts(validation_data[["EA.SMP"]],start = 2010,frequency=17424); #Forecasted System Marginal Price
validation_data.EP2_LOAD = ts(validation_data[["SYSTEM_LOAD"]],start = 2010,frequency=17424); #True Load
validation_data.EA_LOAD = ts(validation_data[["EA.SYSTEM_LOAD"]],start = 2010,frequency=17424); #Forecasted Load
validation_data.EP2_WIND = ts(validation_data[["Eirgrid.WIND"]],start = 2010,frequency=17424); #Actual Wind
validation_data.EA_WIND = ts(validation_data[["SEMO.WIND.FORECAST_MW"]],start = 2010,frequency=17424); #Forecasted Wind
validation_data.SHADOW = ts(validation_data[["EA.SHADOW_PRICE"]],start = 2010,frequency=17424); #Shaddow Price

test_data.EP2_SMP = ts(test_data[["SMP"]],start = end(validation_data.EP2_SMP),frequency=17424); #True System Marginal Price
test_data.EA_SMP = ts(test_data[["EA.SMP"]],start = end(validation_data.EP2_SMP),frequency=17424); #Forecasted System Marginal Price
test_data.EP2_LOAD = ts(test_data[["SYSTEM_LOAD"]],start = end(validation_data.EP2_SMP),frequency=17424); #True Load
test_data.EA_LOAD = ts(test_data[["EA.SYSTEM_LOAD"]],start = end(validation_data.EP2_SMP),frequency=17424); #Forecasted Load
test_data.EP2_WIND = ts(test_data[["Eirgrid.WIND"]],start = end(validation_data.EP2_SMP),frequency=17424); #Actual Wind
test_data.EA_WIND = ts(test_data[["SEMO.WIND.FORECAST_MW"]],start = end(validation_data.EP2_SMP),frequency=17424); #Forecasted Wind
test_data.SHADOW = ts(test_data[["EA.SHADOW_PRICE"]],start = end(validation_data.EP2_SMP),frequency=17424); #Shaddow Price


data2010.EP2_SMP = ts(data2010[["SMP"]],start = 2010,frequency=17424); #True System Marginal Price
data2010.EA_SMP = ts(data2010[["EA.SMP"]],start = 2010,frequency=17424); #Forecasted System Marginal Price
data2010.EP2_LOAD = ts(data2010[["SYSTEM_LOAD"]],start = 2010,frequency=17424); #True Load
data2010.EA_LOAD = ts(data2010[["EA.SYSTEM_LOAD"]],start = 2010,frequency=17424); #Forecasted Load
data2010.EP2_WIND = ts(data2010[["Eirgrid.WIND"]],start = 2010,frequency=17424); #Actual Wind
data2010.EA_WIND = ts(data2010[["SEMO.WIND.FORECAST_MW"]],start = 2010,frequency=17424); #Forecasted Wind
data2010.SHADOW = ts(data2010[["EA.SHADOW_PRICE"]],start = 2010,frequency=17424); #Shaddow Price

data2011.EP2_SMP = ts(data2011[["SMP"]],start = 2011,frequency=17424);
data2011.EA_SMP = ts(data2011[["EA.SMP"]],start = 2011,frequency=17424); 
data2011.EP2_LOAD = ts(data2011[["SYSTEM_LOAD"]],start = 2011,frequency=17424);
data2011.EA_LOAD = ts(data2011[["EA.SYSTEM_LOAD"]],start = 2011,frequency=17424);
data2011.EP2_WIND = ts(data2011[["Eirgrid.WIND"]],start = 2011,frequency=17424);
data2011.EA_WIND = ts(data2011[["SEMO.WIND.FORECAST_MW"]],start = 2011,frequency=17424);
data2011.SHADOW = ts(data2011[["EA.SHADOW_PRICE"]],start = 2011,frequency=17424);