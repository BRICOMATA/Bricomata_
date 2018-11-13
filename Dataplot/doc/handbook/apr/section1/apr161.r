R commands and output:

## Evaluate the PDF at 100 hours for an exponential with lambda = 0.01.
dexp(100,0.01)

> [1] 0.003678794

## Evaluate the CDF at 100 hours for an exponential with lambda = 0.01.
pexp(100,0.01)

> [1] 0.6321206

## Generate an exponential probability plot, normalized so that a
## perfect exponential fit is a diagonal line with slope 1.

## Generate 100 random exponential values using lambda = 0.01.
Y = rexp(100,0.01)

## Generate theoretical quantiles of the exponential distribution.
library(MASS)
p = fitdistr(Y,"exponential")
simdata <- qexp(ppoints(length(Y)), rate=p$estimate)

## Generate probability plot.
qqplot(simdata, Y, xlab="Theoretical Quantiles")
abline(a=0, b=1, lty=3)