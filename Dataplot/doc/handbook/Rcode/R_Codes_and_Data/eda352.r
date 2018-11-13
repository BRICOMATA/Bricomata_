R commands and output:

## Read data and compute summary statistics.
y <- scan("zarr13.dat",skip=25)
ybar = mean(y)
std = sd(y)
n = length(y)
stderr = std/sqrt(n)
Statistics = c(round(length(y),0),round(ybar,5),round(std,5),
               round(stderr,5))
names(Statistics)= c("Number of Observations ", "Mean", "Std. Dev.", 
                     "Std. Dev. of Mean")

## Compute confidence intervals.
alpha = c(.5, .25, .10, .05, .01, .001, .0001, .00001)
Conf.Level = 100*(1-alpha)
Tvalue = qt(1-alpha/2,df=n-1)
Halfwidth = Tvalue*stderr
Lower = ybar - Tvalue*stderr
Upper = ybar + Tvalue*stderr
ci = round(cbind(alpha, Conf.Level, Tvalue, Halfwidth, Lower, Upper),6)

## Print results.
data.frame(Statistics)
>                         Statistics
> Number of Observations   195.00000
> Mean                       9.26146
> Std. Dev.                  0.02279
> Std. Dev. of Mean          0.00163

data.frame(ci)

>     alpha Conf.Level   Tvalue Halfwidth    Lower    Upper
> 1 0.50000     50.000 0.675756  0.001103 9.260358 9.262564
> 2 0.25000     75.000 1.153804  0.001883 9.259578 9.263344
> 3 0.10000     90.000 1.652746  0.002697 9.258764 9.264158
> 4 0.05000     95.000 1.972268  0.003219 9.258242 9.264679
> 5 0.01000     99.000 2.601409  0.004245 9.257215 9.265706
> 6 0.00100     99.900 3.341382  0.005453 9.256008 9.266914
> 7 0.00010     99.990 3.973014  0.006484 9.254977 9.267944
> 8 0.00001     99.999 4.536689  0.007404 9.254057 9.268864


## Perform one sample t-test.
z = t.test(y,alternative="two.sided",mu=5)

>         One Sample t-test
> data:  y 
> t = 2611.286, df = 194, p-value < 2.2e-16
> alternative hypothesis: true mean is not equal to 5 
> 95 percent confidence interval:
>  9.258242 9.264679 
> sample estimates:
> mean of x 
>   9.26146 


