# R commands and output:

## Read the data and save as a time series object.
table = matrix(scan(g_series.dat), ncol=1, byrow=TRUE)
vec = ts(table)

## Load the necessary libraries.
library(stats)
library(lawstat)

## Plot the data print summary statistics.
par(mfrow=c(1,1), cex=1.2)
plot(1:length(vec),vec, type="o", pch=18, col="blue",
     xlab = "Observation", ylab="Series G")
print(summary(vec))

## Take natural log of original series and plot the results.
lvec = log(vec)
par(mfrow=c(1,1), cex=1.2)
plot(1:length(vec),lvec, type="o", pch=18, col="red",
	xlab = "Observation", ylab="ln(Series G)")

## Take first differences of transformed series to remove trend 
## and plot the transformed and differenced data.
fd = diff(lvec)
par(mfrow=c(1,1), cex=1.2)
plot(fd, type="o", pch=18,  col="darkblue",
	xlab = "Observation", ylab="Differenced ln(Series G)")

## Compute the autocorrelation of the transformed and differenced series.
ac <- acf(fd, type = c("correlation"), lag.max=36, main="Autocorrelation of Series G")

## Print ACF for first 36 lags.
round(c(ac$acf),4)

##>  [1]  1.0000  0.1998 -0.1201 -0.1508 -0.3221 -0.0840  0.0258 -0.1110 -0.3367
##> [10] -0.1156 -0.1093  0.2059  0.8414  0.2151 -0.1396 -0.1160 -0.2789 -0.0517
##> [19]  0.0125 -0.1144 -0.3372 -0.1074 -0.0752  0.1995  0.7369  0.1973 -0.1239
##> [28] -0.1027 -0.2110 -0.0654  0.0157 -0.1154 -0.2893 -0.1269 -0.0407  0.1474
##> [37]  0.6574

## Plot the ACF with 95 % confidence limits.
par(mfrow=c(1,1), cex=1.2)
plot(ac, ci=.95, ci.type="ma", main="ACF with 95 % Confidence Limits",
     ylim=c(-1,1))

##  Take seasonal differences of the transformed and differenced series.
sfd = diff(fd, lag=12)

## Plot final time series.
par(mfrow=c(1,1), cex=1.2)
plot(sfd, type="o", pch=18,  col="red", xlab = "Observation", 
     ylab="Seasonal and First Differenced ln(Series G)")

## Compute autocorrelation of final series.
sac = acf(sfd, type = c("correlation"), lag.max=36, 
           main="Autocorrelation of Series G")

## Plot the ACF of differenced series with 95 % confidence limits.
par(mfrow=c(1,1), cex=1.2)
plot(sac, ci=.95, ci.type="ma", main="ACF with 95 % Confidence Limits",
     ylim = c(-1,1))

## Fit a MA model to original series.  The arima function will 
## perform the necessary differences.
ma = arima(log(vec), order = c(0, 1, 1), 
            seasonal=list(order=c(0,1,1), period=12))
ma

##> Call:
##> arima(x = log(vec), order = c(0, 1, 1), seasonal = list(order = c(0, 1, 1), 
##>     period = 12))

##> Coefficients:
##>           ma1     sma1
##>       -0.4018  -0.5569
##> s.e.   0.0896   0.0731

##> sigma^2 estimated as 0.001348:  log likelihood = 244.7,  aic = -483.4

## Use the Box-Ljung test to determine if the residuals are 
## random up to 30 lags.
BT = Box.test(ma$residuals, lag=30, type = "Ljung-Box", fitdf=2)
BT

##>         Box-Ljung test
##> 
##> data:  ma$residuals 
##> X-squared = 29.4935, df = 30, p-value = 0.3878

## Although the output indicates that the degrees of freedom for 
## the test are 30, the p-value is based on df-fitdf = 30-2 = 28.
1-pchisq(29.4935,28)

##> [1] 0.3878282

## Determine critical region.
qchisq(0.95,28)

##> [1] 41.33714

## Generate predictions of 12 future values.
p = predict(ma,12)

## Compute 90% confidence intervals for each prediction
## and convert back to original units.
L90 = exp(p$pred - 1.645*p$se)
U90 = exp(p$pred + 1.645*p$se)

## Generate forecasts in original units.  To avoid under-predicting,
## the forecasts are adjusted to account for log transformation.
Forecast = exp(p$pred + ma$sigma2/2)

## Print the forecast results.
Period = c((length(vec)+1):(length(vec)+12))
df = data.frame(Period,L90,Forecast,U90)
print(df,row.names=FALSE)

##>   Period      L90 Forecast      U90
##>      145 424.0234 450.7261 478.4649
##>      146 396.7861 426.0042 456.7577
##>      147 442.5731 479.3298 518.4399
##>      148 451.3902 492.7365 537.1454
##>      149 463.3034 509.3982 559.3245
##>      150 527.3754 583.7383 645.2544
##>      151 601.9371 670.4625 745.7830
##>      152 595.7602 667.5274 746.9323
##>      153 495.7137 558.5657 628.5389
##>      154 439.1900 497.5430 562.8899
##>      155 377.7598 430.1618 489.1730
##>      156 417.3149 477.5643 545.7760

## Plot last 36 observations and the predictions with confidence limits.
par(mfrow=c(1,1), cex=1.2)
plot(c(108:144),table[108:144],xlim=c(108,160),ylim=c(300,800), type="o",
     ylab="Series G", xlab="Observation", col="black",
     main="12 Forecasts and 90% Confidence Intervals")
points(Forecast, pch=16, col="blue")
lines(c(145:156), L90, col="red")
lines(c(145:156), U90, col="red")


