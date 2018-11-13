R commands and output:

## Read data.
y <- scan("mavro.dat",fname,skip=25)
t = 1:length(y)


## Generate a 4-plot of the data.
library(Hmisc)
par(mfrow = c(2, 2),
      oma = c(0, 0, 2, 0),
      mar = c(5.1, 4.1, 2.1, 2.1)) 
plot(t,y,ylab="Y",xlab="Run Sequence")
plot(y,Lag(y),xlab="Y[i-1]",ylab="Y[i]")
hist(y,main="",xlab="Y")
qqnorm(y,main="")
mtext("Filter Transmittance Data: 4-Plot", line = 0.5, outer = TRUE)

## Generate run sequence plot.
par(mfrow=c(1,1))
plot(t,y,ylab="Y",xlab="Index",type="l")

## Generate lag plot.
par(mfrow=c(1,1))
plot(y,Lag(y),xlab="Y[i-1]",ylab="Y[i]")


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
> Number of Observations    50.00000
> Mean                       2.00186
> Std. Dev.                  0.00043
> Std. Dev. of Mean          0.00006
> Variance                   0.00000
> Range                      0.00140
> Lower Hinge                2.00150
> Upper Hinge                2.00210
> Inter-Quartile Range       0.00060
> Autocorrelation            0.93799

summary(y)

>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
>   2.001   2.002   2.002   2.002   2.002   2.003 


## Generate index variable and fit straight line.
x = c(1:length(y))
summary(lm(y ~ 1 + x))

> Call:
> lm(formula = y ~ 1 + x)
>
> Residuals:
>        Min         1Q     Median         3Q        Max 
> -5.837e-04 -3.294e-04  5.234e-05  2.952e-04  5.208e-04 
>
> Coefficients:
>              Estimate Std. Error   t value Pr(>|t|)    
> (Intercept) 2.001e+00  9.695e-05 20644.046  < 2e-16 ***
> x           1.847e-05  3.309e-06     5.582 1.09e-06 ***
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
>
> Residual standard error: 0.0003376 on 48 degrees of freedom
> Multiple R-squared: 0.3936,     Adjusted R-squared: 0.381 
> F-statistic: 31.15 on 1 and 48 DF,  p-value: 1.085e-06 


## Load the car library, generate an arbitrary interval indicator 
## variable and run Levene's test.
library(car)
int = as.factor(c(rep(1,each=13),rep(2:3,each=12),rep(4,each=13)))
levene.test(y,int)

> Levene's Test for Homogeneity of Variance
>       Df F value Pr(>F)
> group  3  0.9445 0.4269
>       46  

## Generate critical value.
qf(.975,3,46)

##> [1] 2.806845


## Generate and plot the autocorrelation function.
corr <- acf(y, lag.max=12,ci=c(.95,.99),main="")
corr$acf[2]

> 0.9379892

sig_level <- qnorm((1 + 0.95)/2)/sqrt(corr$n.used)
sig_level

> 0.2771808


## Load the lawstat library and perform runs test.
library(lawstat)
runs.test(y)

>     Runs Test - Two sided
>
> data:  y 
> Standardized Runs Statistic = -5.3246, p-value = 1.012e-07