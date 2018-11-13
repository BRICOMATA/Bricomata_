R commands and output:

## Read normal data.
y <- scan("randn.dat",skip=25)


## Generate a 4-plot of the data. 
library(Hmisc)
t = 1:length(y)
par(mfrow = c(2, 2),
      oma = c(0, 0, 2, 0),
      mar = c(5.1, 4.1, 2.1, 2.1)) 
plot(t,y,ylab="Y",xlab="Run Sequence",type="l")
plot(y,Lag(y),xlab="Y[i-1]",ylab="Y[i]")
hist(y,main="",xlab="Y")
qqnorm(y,main="")
mtext("Normal Random Numbers:  4-Plot", line = 0.5, outer = TRUE)

## Generate separate plots to show more detail.
par(mfrow=c(1,1))
plot(t,y,ylab="Y",xlab="Index",type="l")
plot(y,Lag(y),xlab="Y[i-1]",ylab="Y[i]")
hist(y,main="",xlab="Y",freq=FALSE)
curve(dnorm(x,mean=mean(y),sd=sd(y)), add=TRUE, col="blue")
qqnorm(y,main="")
qqline(y,col=2)


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
> Mean                      -0.00294
> Std. Dev.                  1.02104
> Std. Dev. of Mean          0.04566
> Variance                   1.04253
> Range                      6.08300
> Lower Hinge               -0.72100
> Upper Hinge                0.64550
> Inter-Quartile Range       1.36525
> Autocorrelation            0.04506

summary(y)

>      Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
> -2.647000 -0.720500 -0.093000 -0.002936  0.644700  3.436000 


## Generate index variable and fit straight line.
x = c(1:length(y))
summary(lm(y ~ 1 + x))

> Call:
> lm(formula = y ~ 1 + x)
>
> Residuals:
>     Min      1Q  Median      3Q     Max 
> -2.6372 -0.7095 -0.0908  0.6485  3.4307 
>
> Coefficients:
>               Estimate Std. Error t value Pr(>|t|)
> (Intercept)  6.991e-03  9.155e-02   0.076     0.94
> x           -3.963e-05  3.167e-04  -0.125     0.90
>
> Residual standard error: 1.022 on 498 degrees of freedom
> Multiple R-squared: 3.145e-05,  Adjusted R-squared: -0.001977 
> F-statistic: 0.01566 on 1 and 498 DF,  p-value: 0.9005 


## Generate arbitrary interval indicator variable and
## run Bartlett's test.
int = as.factor(rep(1:4,each=125))
bartlett.test(y~int)

>         Bartlett test of homogeneity of variances
>
> data:  y by int 
> Bartlett's K-squared = 2.3737, df = 3, p-value = 0.4986

## Determine critical value for the test.
qchisq(.95,3)

> [1] 7.814728


## Generate and plot the autocorrelation function.
z = acf(y,lag.max=21)
plot(z,ci=c(.90,.95),main="",ylab="Autocorrelation")


## Load the lawstat library and perform runs test.
library(lawstat)
runs.test(y)

>         Runs Test - Two sided
>
> data:  y 
> Standardized Runs Statistic = -1.0744, p-value = 0.2826


## Load the nortest library and perform the Anderson-Darling
## normality test.
library(nortest)
ad.test(y)

>         Anderson-Darling normality test
>
> data:  y 
> A = 1.0612, p-value = 0.008626


## Load the outliers library and perform the Grubbs test.
library(outliers)
grubbs.test(y,type=10)

>         Grubbs test for one outlier
>
> data:  y 
> G = 3.3681, U = 0.9772, p-value = 0.1774
> alternative hypothesis: highest value 3.436 is an outlier 

