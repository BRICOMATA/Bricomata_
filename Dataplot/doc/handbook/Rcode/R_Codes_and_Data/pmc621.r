R commands and output:

## Read data and save variable as a time series object.
size = ts(scan("monitor-6.6.2.1.dat"))

## Generate run-order plot.
plot(size, ylab="Size", xlab="Sequence", main="Run-Order Plot")

## Generate autocorrelation plot with 95 % confidence bands.
acf(size, type = c("correlation"), lag.max=50, 
    main="Autocorrelation of Size", ylim=c(-0.5,1))

## Take first differences.
dsize = diff(size)
plot(dsize, ylab="Size", xlab="Sequence", 
     main="Run-Order Plot of Differenced Data")

## Generate autocorrelation plot of first differenced data.
acf(dsize, type = c("correlation"), lag.max=50, 
    main="Autocorrelation of Differenced Data With 95 % Confidence Bands", 
    ylim=c(-.5,1))

## Generate partial autocorrelation plot of first differenced data.
pacf(dsize, lag.max=50, 
     main="Partial Autocorrelation of Differenced Data",
     sub="95 % Confidence Bands")


## Fit the AR(2) model to differenced series.
ar2 = arima(dsize, order=c(2,0,0))
ar2

##> Call:
##> arima(x = dsize, order = c(2, 0, 0))

##> Coefficients:
##>           ar1      ar2  intercept
##>       -0.4064  -0.1649    -0.0050
##> s.e.   0.0419   0.0419     0.0119

##> sigma^2 estimated as 0.1956:  log likelihood = -336.55,  aic = 681.1

## Compute 95 % confidence intervals for each parameter.
lo = ar2$coef[1] - qnorm(.975)*sqrt(ar2$var.coef[1,1])
up = ar2$coef[1] + qnorm(.975)*sqrt(ar2$var.coef[1,1])
ar1_ci = c(lo,up)
names(ar1_ci) = c("ar1 LCL", "ar1 UCL")
ar1_ci

##>    ar1 LCL    ar1 UCL 
##> -0.4884159 -0.3243078

lo = ar2$coef[2] - qnorm(.975)*sqrt(ar2$var.coef[2,2])
up = ar2$coef[2] + qnorm(.975)*sqrt(ar2$var.coef[2,2])
ar2_ci = c(lo,up)
names(ar2_ci) = c("ar2 LCL", "ar2 UCL")
ar2_ci

##>         ar2         ar2 
##> -0.24693260 -0.08287961


## Fit MA(1) model to detrended size data.
ma <- arima(dsize, order = c(0, 0, 1), include.mean=TRUE)
ma

##> Call:
##> arima(x = dsize, order = c(0, 0, 1), include.mean = TRUE)

##> Coefficients:
##>           ma1  intercept
##>       -0.3921    -0.0051
##> s.e.   0.0366     0.0114

##> sigma^2 estimated as 0.1966:  log likelihood = -338,  aic = 681.99

## Compute 95 % confidence intervals for ma1.
lo = ma$coef[1] - qnorm(.975)*sqrt(ma$var.coef[1,1])
up = ma$coef[1] + qnorm(.975)*sqrt(ma$var.coef[1,1])
ma1_ci = c(lo,up)
names(ma1_ci) = c("ma1 LCL", "ma1 UCL")
ma1_ci

##>    ma1 LCL    ma1 UCL 
##> -0.4638111 -0.3204770


## Attach library Hmisc and generate a 4-plot of the residuals
## from the AR(2) model.
library(Hmisc)
par(mfrow=c(2,2))
plot(ar2$residuals,ylab="AR(2) Residuals",type="l")
plot(Lag(ar2$residuals,1),ar2$residuals,
     ylab="AR(2) Residuals",xlab="lag(AR(2) Residuals)")
hist(ar2$residuals,main="",xlab="AR(2) Residuals",breaks=20)
qqnorm(ar2$residuals,main="")
par(mfrow=c(1,1))


## Generate autocorrelation Plot of Residuals from ARIMA(2) Model
acf(ar2$residuals, lag.max=50, main="Residuals from the ARIMA(2,1,0) Model")


## Perform Ljung-Box Test for Randomness for the ARIMA(2,1,0) Model
Box.test(ar2$residuals, lag=24, type = "Ljung-Box")

##>         Box-Ljung test
##>
##> data:  ar2$residuals 
##> X-squared = 31.8409, df = 24, p-value = 0.131


## Generate a 4-plot of the residuals from the MA(1) model.
par(mfrow=c(2,2))
plot(ma$residuals,ylab="MA(1) Residuals",type="l")
plot(Lag(ma$residuals,1),ma$residuals,
     ylab="MA(1) Residuals",xlab="lag(MA(1) Residuals)")
hist(ma$residuals,main="",xlab="MA(1) Residuals",breaks=20)
qqnorm(ma$residuals,main="")
par(mfrow=c(1,1))


## Generate Autocorrelation Plot of Residuals from MA(1) Model
acf(ma$residuals, lag.max=50, main="Residuals from the MA(1) Model")


## Perform Ljung-Box Test for Randomness of the Residuals 
## for the MA(1) Model
Box.test(ma$residuals, lag=24, type = "Ljung-Box")

##>         Box-Ljung test
##>
##> data:  ma$residuals 
##> X-squared = 37.8865, df = 24, p-value = 0.03561
