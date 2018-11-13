R commands and output:

## Read uniform data.
y = scan("randu.dat",skip=25)


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
mtext("Uniform Random Numbers:  4-Plot", line = 0.5, outer = TRUE)

## Generate separate plots to show more detail.
par(mfrow=c(1,1))
plot(t,y,ylab="Y",xlab="Index",type="l")
plot(y,Lag(y),xlab="Y[i-1]",ylab="Y[i]")

## Plot histogram with overlayed normal distribution.
hist(y,main="",xlab="Y",freq=FALSE,ylim=c(0,1.5))
curve(dnorm(x,mean=mean(y),sd=sd(y)), add=TRUE, col="blue")

## Plot histogram with overlayed uniform distribution.
hist(y,main="",xlab="Y",freq=FALSE,ylim=c(0,1.5))
curve(dunif(x), add=TRUE, col="blue")

## Normal probability plot.
qqnorm(y,main="")
qqline(y,col=2)

## Uniform probability plot.
library(gap)
qqunif(y,main="")


## Attach boot library and generate values for bootstrap plot.
library(boot)

## Bootstrap and CI for mean.  d is a vector of integer indexes
samplemean <- function(x, d) {
  return(mean(x[d]))                   
}
b1 = boot(y, samplemean, R=500)   
z1 = boot.ci(b1, conf=0.9, type="basic")
meanci = paste("90% CI: ", "(", round(z1$basic[4],4), ", ", 
               round(z1$basic[5],4), ")", sep="" )

## Bootstrap and CI for median.
samplemedian <- function(x, d) {
  return(median(x[d]))          
}
b2 = boot(y, samplemedian, R=500)
z2 = boot.ci(b2, conf=0.90, type="basic")
medci = paste("90% CI: ", "(", round(z2$basic[4],4), ", ", 
              round(z2$basic[5],4), ")", sep="" )

## Bootstrap and CI for midrange.
samplemidran <- function(x, d) {
  return( (max(x[d])+min(x[d]))/2 )
}
b3 = boot(y, samplemidran, R=500)   
z3 = boot.ci(b3, conf=0.90, type="basic")
midci = paste("90% CI: ", "(", round(z3$basic[4],4), ", ", 
              round(z3$basic[5],4), ")", sep="" )

## Generate bootstrap plot.
par(mfrow=c(2,3))
plot(b1$t,type="l",ylab="Mean",main=meanci)
plot(b2$t,type="l",ylab="Median",main=medci)
plot(b3$t,type="l",ylab="Midrange",main=midci)
hist(b1$t,main="Bootstrap Mean",xlab="Mean")
hist(b2$t,main="Bootstrap Median",xlab="Median")
hist(b3$t,main="Bootstrap Midrange",xlab="Midrange")
par(mfrow=c(1,1))


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
> Mean                       0.50783
> Std. Dev.                  0.29433
> Std. Dev. of Mean          0.01316
> Variance                   0.08663
> Range                      0.99459
> Lower Hinge                0.25059
> Upper Hinge                0.75948
> Inter-Quartile Range       0.50831
> Autocorrelation           -0.03099

summary(y)

>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
> 0.00249 0.25080 0.51840 0.50780 0.75910 0.99710 


## Compute probabilty plot correlation coefficients (PPCC)
## for normal and uniform distributions
x = qqnorm(y)
cor(x$x,y)

> [1] 0.9762727

library(gap)
u = qqunif(y,logscale=FALSE)
cor(u$x,sort(y))

> [1] 0.9995683


## Generate index variable and fit straight line.
x = c(1:length(y))
summary(lm(y ~ 1 + x))

> Call:
> lm(formula = y ~ 1 + x)
>
> Residuals:
>       Min        1Q    Median        3Q       Max 
> -0.504587 -0.259594  0.003748  0.254196  0.494785 
>
> Coefficients:
>               Estimate Std. Error t value Pr(>|t|)    
> (Intercept)  5.229e-01  2.638e-02   19.82   <2e-16 ***
> x           -6.025e-05  9.125e-05   -0.66    0.509    
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
>
> Residual standard error: 0.2945 on 498 degrees of freedom
> Multiple R-squared: 0.0008747,  Adjusted R-squared: -0.001132 
> F-statistic: 0.436 on 1 and 498 DF,  p-value: 0.5094 

## Critical value to test that the slope is different from zero.
qt(.975,498)

> [1] 1.964739


## Load the car library, generate an arbitrary interval indicator 
## variable and run Levene's test.
int = as.factor(rep(1:4,each=125))
library(car)
levene.test(y,int)

> Levene's Test for Homogeneity of Variance
>        Df F value Pr(>F)
> group   3  0.0798  0.971
>       496 

## Upper critical value for the F test.
qf(.95,3,496)

> [1]  2.622879


## Generate and plot the autocorrelation function.
z = acf(y,lag.max=21)
plot(z,ci=c(.90,.95),main="",ylab="Autocorrelation")


## Load the lawstat library and perform runs test.
library(lawstat)
runs.test(y)

>         Runs Test - Two sided
>
> data:  y 
> Standardized Runs Statistic = 0.2686, p-value = 0.7882

## Determine critical value for the test.

qnorm(.975)

> [1] 1.959964


## Load the nortest library and perform the Anderson-Darling
## normality test.
library(nortest)
ad.test(y)

>         Anderson-Darling normality test
>
> data:  y 
> A = 5.7198, p-value = 4.206e-14
