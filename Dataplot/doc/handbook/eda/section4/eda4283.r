R commands and output:

## Read data.
y = scan("zarr13.dat",skip=25)


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
mtext("Heat Flow Meter Data: 4-Plot", line = 0.5, outer = TRUE)

## Generate run order plot.
par(mfrow=c(1,1))
plot(t,y,ylab="Y",xlab="Index",type="l")

## Generate lag plot.
plot(y,Lag(y),xlab="Y[i-1]",ylab="Y[i]")

## Plot histogram with overlayed normal distribution.
hist(y,main="",xlab="Y",freq=FALSE)
curve(dnorm(x,mean=mean(y),sd=sd(y)), add=TRUE, col="blue")

## Normal probability plot.
qqnorm(y,main="")
qqline(y,col=2)


## Compute summary statistics.
ybar = round(mean(y),6)
std = round(sd(y),6)
n = round(length(y),0)
stderr = round(std/sqrt(n),6)
v = round(var(y),6)

# Compute the five number summary.
# min, lower hinge, Median, upper hinge, max
z = fivenum(y)
lhinge = round(z[2],6)
uhinge = round(z[4],6)
rany = round((max(y)-min(y)),6)

## Compute the inter-quartile range.
iqry = round(IQR(y),6)

## Compute the lag 1 autocorrelation.
z = acf(y)
ac = round(z$acf[2],6)

## Format results for printing.
Statistics = c(n,ybar,std,stderr,v,rany,lhinge,uhinge,iqry,ac)
names(Statistics)= c("Number of Observations ", "Mean", "Std. Dev.", 
                "Std. Dev. of Mean", "Variance", "Range",
                "Lower Hinge", "Upper Hinge", "Inter-Quartile Range",
                "Autocorrelation")
data.frame(Statistics)

>                         Statistics
> Number of Observations  195.000000
> Mean                      9.261461
> Std. Dev.                 0.022789
> Std. Dev. of Mean         0.001632
> Variance                  0.000519
> Range                     0.131125
> Lower Hinge               9.246496
> Upper Hinge               9.275530
> Inter-Quartile Range      0.029034
> Autocorrelation           0.280578

summary(y)

>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
>   9.197   9.246   9.262   9.261   9.276   9.328 


## Generate index variable and fit straight line.
x = c(1:length(y))
summary(lm(y ~ 1 + x))

> Call:
> lm(formula = y ~ 1 + x)
>
> Residuals:
>        Min         1Q     Median         3Q        Max 
> -0.0605897 -0.0147354  0.0009425  0.0136395  0.0635789 
>
> Coefficients:
>               Estimate Std. Error t value Pr(>|t|)    
> (Intercept)  9.267e+00  3.253e-03 2848.98   <2e-16 ***
> x           -5.641e-05  2.878e-05   -1.96   0.0514 .  
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
>
> Residual standard error: 0.02262 on 193 degrees of freedom
> Multiple R-squared: 0.01952,    Adjusted R-squared: 0.01444 
> F-statistic: 3.842 on 1 and 193 DF,  p-value: 0.05143


## Generate arbitrary interval indicator variable and
## run Bartlett's test.
int = as.factor(c(rep(1,each=48),rep(2:4,each=49)))
bartlett.test(y~int)

>         Bartlett test of homogeneity of variances
>
> data:  y by int 
> Bartlett's K-squared = 3.1472, df = 3, p-value = 0.3695

## Critical value.
qchisq(.95,3)

> [1] 7.814728


## Generate and plot the autocorrelation function.
corr <- acf(y, lag.max=48,ci=c(.95,.99),main="")
corr$acf[2]

> 0.2805784

sig_level <- qnorm((1 + 0.95)/2)/sqrt(corr$n.used)
sig_level

> 0.1403559


## Load the lawstat library and perform runs test.
library(lawstat)
runs.test(y)

>         Runs Test - Two sided
>
> data:  y 
> Standardized Runs Statistic = -3.2306, p-value = 0.001235


## Load the nortest library and perform the Anderson-Darling
## normality test.
library(nortest)
ad.test(y)

>        Anderson-Darling normality test
>
> data:  y 
> A = 0.1265, p-value = 0.985


## Load the outliers library and perform the Grubbs test.
library(outliers)
grubbs.test(y,type=10)

>         Grubbs test for one outlier
>
> data:  y 
> G = 2.9186, U = 0.9559, p-value = 0.3121
> alternative hypothesis: highest value 9.327973 is an outlier 


## Compute the 95 % confidence interval for the mean.
u = qt(0.975,df=n-1)*std/sqrt(n)
c(ybar-u,ybar+u)

> [1] 9.258242 9.264680
