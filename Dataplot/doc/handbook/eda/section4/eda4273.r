R commands and output:

## Read data.
m = matrix(scan("dziuba1.dat",skip=25),ncol=4,byrow=T)
y = m[,4]


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
mtext("Standard Resitor Data: 4-Plot", line = 0.5, outer = TRUE)

## Generate run order plot.
par(mfrow=c(1,1))
plot(t,y,ylab="Y",xlab="Index",type="l")

## Generate lag plot.
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
> Number of Observations  1000.00000
> Mean                      28.01634
> Std. Dev.                  0.06349
> Std. Dev. of Mean          0.00201
> Variance                   0.00403
> Range                      0.29050
> Lower Hinge               27.97900
> Upper Hinge               28.06295
> Inter-Quartile Range       0.08388
> Autocorrelation            0.97216

summary(y)

>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
>   27.83   27.98   28.03   28.02   28.06   28.12 


## Generate index variable and fit straight line.
x = c(1:length(y))
summary(lm(y ~ 1 + x))

> Call:
> lm(formula = y ~ 1 + x)
>
> Residuals:
>       Min        1Q    Median        3Q       Max 
> -0.093259 -0.012859  0.003605  0.013953  0.051697 
>
> Coefficients:
>              Estimate Std. Error t value Pr(>|t|)    
> (Intercept) 2.791e+01  1.209e-03 23090.8   <2e-16 ***
> x           2.097e-04  2.092e-06   100.2   <2e-16 ***
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
>
> Residual standard error: 0.0191 on 998 degrees of freedom
> Multiple R-squared: 0.9096,     Adjusted R-squared: 0.9095 
> F-statistic: 1.004e+04 on 1 and 998 DF,  p-value: < 2.2e-16 


## Load the car library, generate an arbitrary interval indicator 
## variable and run Levene's test.
library(car)
int = as.factor(rep(1:4,each=250))
levene.test(y,int)

> Levene's Test for Homogeneity of Variance
>        Df F value    Pr(>F)    
> group   3  140.85 < 2.2e-16 ***
>       996                      
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

## Find critical value.
qf(.95,3,996)

> [1] 2.613839


## Generate and plot the autocorrelation function.
corr <- acf(y, lag.max=250,ci=c(.95,.99),main="")
corr$acf[2]

> 0.972159

sig_level <- qnorm((1 + 0.95)/2)/sqrt(corr$n.used)
sig_level

> 0.0619795


## Load the lawstat library and perform runs test.
library(lawstat)
runs.test(y)

>         Runs Test - Two sided
>
> data:  y 
> Standardized Runs Statistic = -30.5629, p-value < 2.2e-16