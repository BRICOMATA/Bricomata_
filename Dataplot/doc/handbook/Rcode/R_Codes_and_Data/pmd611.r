R commands and output:

## Load cell calibration case study

## Create vector with dependent variable, deflection
deflection = c(0.11019, 0.21956, 0.32949, 0.43899, 0.54803, 0.65694,
               0.76562, 0.87487, 0.98292, 1.09146, 1.20001, 1.30822,
               1.41599, 1.52399, 1.63194, 1.73947, 1.84646, 1.95392,
               2.06128, 2.16844, 0.11052, 0.22018, 0.32939, 0.43886,
               0.54798, 0.65739, 0.76596, 0.87474, 0.98300, 1.09150,
               1.20004, 1.30818, 1.41613, 1.52408, 1.63159, 1.73965,
               1.84696, 1.95445, 2.06177, 2.16829)

## Create vector with independent variable, load
load = c(150000, 300000, 450000, 600000, 750000, 900000, 1050000,
         1200000, 1350000, 1500000, 1650000, 1800000, 1950000,
         2100000, 2250000, 2400000, 2550000, 2700000, 2850000,
         3000000, 150000, 300000, 450000, 600000, 750000, 900000,
         1050000, 1200000, 1350000, 1500000, 1650000, 1800000,
         1950000, 2100000, 2250000, 2400000, 2550000, 2700000,
         2850000, 3000000)

## Determine the number of observations
len = length(load)

## Generate regression analysis results
out = lm(deflection~load)
summary(out)

> Call:
> lm(formula = deflection ~ load)
>
> Residuals:
>        Min         1Q     Median         3Q        Max 
> -0.0042751 -0.0016308  0.0005818  0.0018932  0.0024211 
>
> Coefficients:
>              Estimate Std. Error  t value Pr(>|t|)    
> (Intercept) 6.150e-03  7.132e-04    8.623 1.77e-10 ***
> load        7.221e-07  3.969e-10 1819.289  < 2e-16 ***
> ---
> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>
> Residual standard error: 0.002171 on 38 degrees of freedom
> Multiple R-Squared:     1,      Adjusted R-squared:     1 
> F-statistic:  3.31e+06 on 1 and 38 DF,  p-value: < 2.2e-16 

## Plot data overlaid with estimated regression function
par(mfrow=c(1,1),cex=1.25)
plot(load,deflection,xlab="Load",ylab="Deflection",
     pch=16, cex=1.25, col="blue" )
abline(reg=out)

## Plot residuals versus the independent variable, load
par(mfrow=c(1,1),cex=1.25)
plot(load,out$residuals, xlab="Load", ylab="Residuals",
     pch=16, cex=1.25, col="blue")

## Plot residual versus predicted values
par(mfrow=c(1,1),cex=1.25)
plot(out$fitted.values,out$residuals, 
     xlab="Predicted Values from the Straight-Line Model", 
     ylab="Residuals", pch=16, cex=1.25, col="blue")

## 4-Plot of residuals
par(mfrow=c(2,2))
plot(out$residuals,ylab="Residuals",xlab="Observation Number",
     main="Run Order Plot")
plot(out$residuals[2:len],out$residuals[1:len-1],ylab="Residuals",
     xlab="Lag 1 Residuals",main="Lag Plot")
hist(out$residuals,ylab="Frequency",xlab="Residuals",main="Histogram")
qqnorm(out$residuals,main="Normal Probability Plot")
par(mfrow=c(1,1))

## Perform lack-of-fit test
lof = lm(deflection~factor(load))

## Print results.
anova(out,lof)

> Analysis of Variance Table
> 
> Model 1: deflection ~ load
> Model 2: deflection ~ factor(load)
>   Res.Df        RSS Df  Sum of Sq      F    Pr(>F)    
> 1     38 1.7915e-04                                   
> 2     20 9.2200e-07 18 1.7823e-04 214.75 < 2.2e-16 ***
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

## Create variable with squared load
load2 = load*load

## Fit quadratic model
outq = lm(deflection~load + load2)
qq = summary(outq)
qq

> Call:
> lm(formula = deflection ~ load + load2)
>
> Residuals:
>        Min         1Q     Median         3Q        Max 
> -4.468e-04 -1.578e-04  3.817e-05  1.088e-04  4.235e-04 
>
> Coefficients:
>               Estimate Std. Error t value Pr(>|t|)    
> (Intercept)  6.736e-04  1.079e-04    6.24 2.97e-07 ***
> load         7.321e-07  1.578e-10 4638.65  < 2e-16 ***
> load2       -3.161e-15  4.867e-17  -64.95  < 2e-16 ***
> ---
> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>
> Residual standard error: 0.0002052 on 37 degrees of freedom
> Multiple R-Squared:     1,      Adjusted R-squared:     1 
> F-statistic:  1.853e+08 on 2 and 37 DF,  p-value: < 2.2e-16

## Sort data for plotting
upred = deflection - outq$resid
udfout = data.frame(upred,load)
udfout = udfout[order(load),]

## Plot data overlaid with estimated regression function
par(mfrow=c(1,1),cex=1.25)
plot(load,deflection,xlab="Load",ylab="Deflection",
     pch=16, cex=1.25, col="blue")
lines(udfout$load,udfout$upred)

## Plot residuals versus independent variable, load
par(mfrow=c(1,1),cex=1.25)
plot(load,outq$residuals,xlab="Load",ylab="Residuals",
     pch=16, cex=1.25, col="blue")

## Plot residuals versus predicted deflection
par(mfrow=c(1,1),cex=1.25)
plot(outq$fitted.values,outq$residuals,
     ylab="Residuals",xlab="Predicted Values from Quadratic Model",
     pch=16, cex=1.25, col="blue")

## 4-Plot of residuals
par(mfrow=c(2,2))
plot(outq$residuals,ylab="Residuals",xlab="Observation Number",
     main="Run Order Plot")
plot(outq$residuals[2:len],outq$residuals[1:len-1],ylab="Residuals",
     xlab="Lag 1 Residuals",main="Lag Plot")
hist(outq$residuals,ylab="Frequency",xlab="Residuals",main="Histogram")
qqnorm(outq$residuals,main="Normal Probability Plot")
par(mfrow=c(1,1))

## Perform lack-of-fit test
lof = lm(deflection~factor(load))

## Print results.
anova(outq,lof)

> Analysis of Variance Table
>
> Model 1: deflection ~ load + load2
> Model 2: deflection ~ factor(load)
>   Res.Df        RSS Df  Sum of Sq      F Pr(>F)
> 1     37 1.5576e-06                            
> 2     20 9.2215e-07 17 6.3547e-07 0.8107 0.6662

## Solve the regression function for Load
nd = 1.239722
tval = qt(.975,outq$df.residual)
f = function(load) {outq$coef%*%c(1,load,load^2)-nd}
nl = uniroot(f,c(min(load),max(load)))$root
nl

> [1] 1705106

## Plot regression line and desired calibration point
par(mfrow=c(1,1),cex=1.25,srt=0)
plot(load,deflection,ylab="Deflection",xlab="Load",
     pch=16, cex=1.25, col="blue")
abline(h=nd)
text(750000,1.3,"Deflection = 1.239722")
abline(v=nl)
par(srt=-90)
text(1800000,.7,"Load = ???")

## Compute confidence interval for calibration value 
## Create function to calculate the upper lmit
lo = function(load){
rsdm = sqrt(1 + c(1,load,load^2)%*%qq$cov.unscaled%*%c(1,load,load^2))
f(load) + tval*qq$sigma*rsdm
}

## Create function to calculate the lower limit
up = function(load){
rsdm = sqrt(1 + c(1,load,load^2)%*%qq$cov.unscaled%*%c(1,load,load^2))
f(load) - tval*qq$sigma*rsdm
}

## Use the two functions to find the roots
local = uniroot(lo,lower=min(load),upper=max(load))
local$root

> [1] 1704513

upcal = uniroot(up,lower=min(load),upper=max(load))
upcal$root

> [1] 1705698


