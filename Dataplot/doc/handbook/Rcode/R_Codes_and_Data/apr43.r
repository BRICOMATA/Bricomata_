R commands and output:

## Evaluate a lognormal CDF at time T.

T = 100000
T50 = 507383 
sigma = 0.74

y = plnorm(T/T50, sdlog=sigma)
y

> [1] 0.01409169

## Evaluate a use CDF or failure rate for a T-hour stress test 
## for a lognormal distribution.
## T = length of test
## p = proportion of failures
## sigma = shape parameter
## A = acceleration factor

T50STRESS = T*qlnorm(p, sdlog=sigma) 

CDF = plnorm((100000/(A*T50STRESS)), sdlog=sigma)

## Evaluate a use CDF or failure rate for a T-hour stress test
## for a Weibull distribution. 
## gamma = shape parameter

ASTRESS = T*qweibull(p, shape=gamma)

CDF = pweibull((100000/(A*ASTRESS)), gamma)


