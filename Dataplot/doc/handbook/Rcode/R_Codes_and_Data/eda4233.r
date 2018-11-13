R commands and output:

## Read random walk data.
y <- scan("randwalk.dat",skip=25)


## Generate 4-plot.
library(Hmisc)
t = 1:length(y)
par(mfrow = c(2, 2),
      oma = c(0, 0, 2, 0),
      mar = c(5.1, 4.1, 2.1, 2.1)) 
plot(t,y,ylab="Y",xlab="Run Sequence",type="l")
plot(y,Lag(y),xlab="Y[i-1]",ylab="Y[i]")
hist(y,main="",xlab="Y")
qqnorm(y,main="")
mtext("Random Walk:  4-Plot", line = 0.5, outer = TRUE)
par(mfrow=c(2,2))

## Generate spectral plot.
z = spec.pgram(y,kernel,spans=3,plot=FALSE)
plot(z$freq,z$spec,type="l",ylab="Spectrum",xlab="Frequency")


## Compute summary statistics.
ybar = round(mean(y),5)
std = round(sd(y),5)
n = round(length(y),0)
stderr = round(std/sqrt(n),5)
v = round(var(y),5)

# Compute the five number summary.
# min, lower hinge, Median, upper hinge, max
z = fivenum(y)
lhinge = round(z[2],5)
uhinge = round(z[4],5)
rany = round((max(y)-min(y)),5)

## Compute the inter-quartile range.
iqry = round(IQR(y),5)

## Compute the lag 1 autocorrelation.
z = acf(y)
ac = round(z$acf[2],5)

## Format results for printing.
Statistics = c(n,ybar,std,stderr,v,rany,lhinge,uhinge,iqry,ac)
names(Statistics)= c("Number of Observations ", "Mean", "Std. Dev.", 
                "Std. Dev. of Mean", "Variance", "Range",
                "Lower Hinge", "Upper Hinge", "Inter-Quartile Range",
                "Autocorrelation")
data.frame(Statistics)

>                         Statistics
> Number of Observations   500.00000
> Mean                       3.21668
> Std. Dev.                  2.07867
> Std. Dev. of Mean          0.09296
> Variance                   4.32089
> Range                      9.05359
> Lower Hinge                1.74104
> Upper Hinge                4.68227
> Inter-Quartile Range       2.93447
> Autocorrelation            0.98686

summary(y)

>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
>  -1.638   1.747   3.612   3.217   4.682   7.415 


## Generate index variable and fit straight line.
x = c(1:length(y))
summary(lm(y ~ 1 + x))

> Call:
> lm(formula = y ~ 1 + x)
>
> Residuals:
>      Min       1Q   Median       3Q      Max 
> -3.76455 -1.56702 -0.09758  1.59580  4.33380 
>
> Coefficients:
>              Estimate Std. Error t value Pr(>|t|)    
> (Intercept) 1.8335107  0.1721148  10.653   <2e-16 ***
> x           0.0055216  0.0005953   9.275   <2e-16 ***
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
>
> Residual standard error: 1.921 on 498 degrees of freedom
> Multiple R-squared: 0.1473,     Adjusted R-squared: 0.1456 
> F-statistic: 86.02 on 1 and 498 DF,  p-value: < 2.2e-16 


## Load the car library, generate an arbitrary interval indicator 
## variable and run Levene's test.
int = as.factor(rep(1:4,each=125))
library(car)
levene.test(y,int)

> Levene's Test for Homogeneity of Variance
>        Df F value    Pr(>F)    
> group   3  10.459 1.106e-06 ***
>       496                      
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

## Critical value.
qf(.95,3,496)

> [1] 2.622879


## Load the lawstat library and perform runs test.
library(lawstat)
runs.test(y)

>         Runs Test - Two sided
>
> data:  y 
> Standardized Runs Statistic = -20.3239, p-value < 2.2e-16

## Determine critical value for the test.
qnorm(.975)

> [1] 1.959964


## Attach Hmisc library and perform the linear fit.
library(Hmisc)
z = lm(y ~ Lag(y))
summary(z)

> Call:
> lm(formula = y ~ Lag(y))
>
> Residuals:
>       Min        1Q    Median        3Q       Max 
> -0.519254 -0.245457  0.001945  0.244185  0.507424 
>
> Coefficients:
>             Estimate Std. Error t value Pr(>|t|)    
> (Intercept) 0.050165   0.024171   2.075   0.0385 *  
> Lag(y)      0.987087   0.006313 156.350   <2e-16 ***
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

> Residual standard error: 0.2931 on 497 degrees of freedom
>   (1 observation deleted due to missingness)
> Multiple R-squared: 0.9801,     Adjusted R-squared:  0.98 
> F-statistic: 2.445e+04 on 1 and 497 DF,  p-value: < 2.2e-16 


## Generate plot of predicted versus observed.
p = predict(z)
plot(p,y[-1],xlab="Y",ylab="Predicted")


## Generate 4-plot of residuals.
t = 1:length(z$residual)
par(mfrow = c(2, 2),
      oma = c(0, 0, 2, 0),
      mar = c(5.1, 4.1, 2.1, 2.1)) 
plot(t,z$residuals,ylab="Residuals",xlab="Run Sequence",type="l")
plot(z$residual,Lag(z$residual),xlab="Residual[i-1]",ylab="Residual[i]")
hist(z$residual,main="",xlab="Residual")
qqnorm(z$residual,main="")
mtext("Random Walk:  4-Plot", line = 0.5, outer = TRUE)
par(mfrow=c(1,1))


## Generate uniform probability plot.
library(gap)
qqunif(z$residuals,main="",logscale=FALSE,lcol=0)