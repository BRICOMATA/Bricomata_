R commands and output:

## Read data.
y <- scan("soulen.dat",skip=25)


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
mtext("Voltage Counts:  4-Plot", line = 0.5, outer = TRUE)

## Generate separate plots to show more detail.
par(mfrow=c(1,1))
plot(t,y,ylab="Y",xlab="Index",type="l")
plot(y,Lag(y),xlab="Y[i-1]",ylab="Y[i]")

## Plot histogram with overlayed normal distribution.
hist(y,main="",xlab="Y",freq=FALSE)
curve(dnorm(x,mean=mean(y),sd=sd(y)), add=TRUE, col="blue")

## Normal probability plot.
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
> Number of Observations   700.00000
> Mean                    2898.56143
> Std. Dev.                  1.30497
> Std. Dev. of Mean          0.04932
> Variance                   1.70295
> Range                      7.00000
> Lower Hinge             2898.00000
> Upper Hinge             2899.00000
> Inter-Quartile Range       1.00000
> Autocorrelation            0.31480

summary(y)

>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
>    2895    2898    2899    2899    2899    2902 


## Generate index variable and fit straight line.
x = c(1:length(y))
summary(lm(y ~ 1 + x))

> Call:
> lm(formula = y ~ 1 + x)
>
> Residuals:
>     Min      1Q  Median      3Q     Max 
> -3.5716 -0.7576  0.0804  0.7756  3.7743 
>
> Coefficients:
>              Estimate Std. Error   t value Pr(>|t|)    
> (Intercept) 2.898e+03  9.745e-02 29739.288  < 2e-16 ***
> x           1.071e-03  2.409e-04     4.445 1.02e-05 ***
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
>
> Residual standard error: 1.288 on 698 degrees of freedom
> Multiple R-squared: 0.02753,    Adjusted R-squared: 0.02614 
> F-statistic: 19.76 on 1 and 698 DF,  p-value: 1.021e-05 


## Load the car library, generate an arbitrary interval indicator 
## variable and run Levene's test.
int = as.factor(rep(1:4,each=175))
library(car)
levene.test(y,int)

> Levene's Test for Homogeneity of Variance
>        Df F value Pr(>F)
> group   3  1.4324 0.2321
>       696 

## Critical value.
qf(.95,3,696)

> [1] 2.6177


## Generate and plot the autocorrelation function.
corr <- acf(y, lag.max=175,ci=c(.95,.99),main="")
sig_level <- qnorm((1 + 0.95)/2)/sqrt(corr$n.used)
sig_level


## Load the lawstat library and perform runs test.
library(lawstat)
runs.test(y)

>         Runs Test - Two sided
>
> data:  y 
> Standardized Runs Statistic = -13.4162, p-value < 2.2e-16


## Load the outliers library and perform the Grubbs test.
library(outliers)
grubbs.test(y,type=10)

>         Grubbs test for one outlier
> 
> data:  y 
> G = 2.7291, U = 0.9893, p-value = 1
> alternative hypothesis: lowest value 2895 is an outlier 

