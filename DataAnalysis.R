# Author: Peter Barrett
# Price Forecasting for the Irish Electricity Market using Machine Learning
#
# Summary: 
# Time Series Analysis on data to find useful features
#

#Detrending
#ACF and CCF

#detrend Time series
#SMP
par(mfrow=c(3,1))
Linear_SMP <-lm(EP2_SMP_2010~time(EP2_SMP_2010), na.action=NULL)
SMP_detrended <- resid(Linear_SMP)
SMP_first_diff <- diff(EP2_SMP_2010)
plot(EP2_SMP_2010,main="SMP Normal Time Series")
plot(SMP_detrended,main="SMP Detrended")
plot(SMP_first_diff,main="SMP First Difference")

#System Load
par(mfrow=c(3,1))
Linear_SYSTEM_LOAD <-lm(EP2_SYSTEM_LOAD_2010~time(EP2_SYSTEM_LOAD_2010), na.action=NULL)
SYSTEM_LOAD_detrended <- resid(Linear_SYSTEM_LOAD)
SYSTEM_LOAD_first_diff <- diff(SYSTEM_LOAD_TS)
plot(SYSTEM_LOAD_TS,main="System Load Normal Time Series")
plot(SYSTEM_LOAD_detrended,main="System Load Detrended")
plot(SYSTEM_LOAD_first_diff ,main="System Load First Difference")

#Wind
par(mfrow=c(3,1))
Linear_WIND <-lm(WIND_TS~time(WIND_TS), na.action=NULL)
WIND_detrended <- resid(Linear_WIND)
WIND_first_diff <- diff(WIND_TS)
plot(WIND_TS,main="Wind Normal Time Series")
plot(WIND_detrended,main="Wind Detrended")
plot(WIND_first_diff ,main="Wind First Difference")

#EA SHADOW 
Linear_SHADOW <-lm(SHADOW_TS~time(SHADOW_TS), na.action=NULL)
SHADOW_detrended <- resid(Linear_SHADOW)
SHADOW_first_diff <- diff(SHADOW_TS)
plot(SHADOW_TS,main="SHADOW Normal Time Series")
plot(SHADOW_detrended,main="SHADOW Detrended")
plot(SHADOW_first_diff,main="SHADOW First Difference")

acf(SHADOW_detrended,lag= 96)
ccf(SHADOW_TS,EP2_SMP_2010,lag = 96)

#ACF
par(mfrow=c(3,1))
acf(EP2_SMP_2010,lag=96);
acf(SMP_detrended,lag=96);
acf(SMP_first_diff,lag=96);

par(mfrow=c(3,1))
acf(SYSTEM_LOAD_TS,lag=96);
acf(SYSTEM_LOAD_detrended,lag=96);
acf(SYSTEM_LOAD_first_diff,lag=96);

par(mfrow=c(3,1));
acf(WIND_TS,lag=96);
acf(WIND_detrended,lag=96);
acf(WIND_first_diff,lag=96);

#CCF
par(mfrow=c(3,1));
ccf(SYSTEM_LOAD_TS,EP2_SMP_2010,lag=96);
ccf(SYSTEM_LOAD_detrended,SYSTEM_LOAD_TS,lag=96);
ccf(SYSTEM_LOAD_detrended,SMP_first_diff,lag=96);
ccf(SYSTEM_LOAD_first_diff,SMP_first_diff,lag=96);

par(mfrow=c(3,1));
ccf(SMP_detrended,EP2_SMP_2010,lag=96);
ccf(WIND_TS,EP2_SMP_2010,lag=96);
ccf(WIND_detrended,EP2_SMP_2010,lag=96);
ccf(WIND_detrended,SMP_detrended,lag=96);
