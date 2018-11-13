R commands and output:

## Attach "nortest" library and define sample size.
library(nortest)
n=1000


## Generate 1000 standard normal random numbers 
## and perform the Anderson-Darling test.
set.seed(403)
y1 = rnorm(n, mean = 0, sd = 1)
ad.test(y1)

>         Anderson-Darling normality test
>
> data:  y1 
> A = 0.3093, p-value = 0.5568


## Generate 1000 double exponential random numbers 
## and perform the Anderson-Darling test.
set.seed(403)
y2 = rexp(n,rate=1) - rexp(n,rate=1)
ad.test(y2)

>         Anderson-Darling normality test
>
> data:  y2 
> A = 13.6652, p-value < 2.2e-16


## Generate 1000 Cauchy random numbers and perform the 
## Anderson-Darling test.
##
## We set the seed=0 to ensure reproducibility of results.  
## Cauchy random number generators can produce very extreme 
## values.  A different seed will produce different results.
##
## Extreme values, such as might be encountered with 
## Cauchy-type data, can result in "Inf" values for the 
## Anderson-Darling test, and this is indicative of the 
## numerical limits of the Anderson-Darling implementation.  
## The p-value is not meaningful in this case.
set.seed(0)
y3 = rcauchy(n, location = 0, scale = 1)
ad.test(y3)

>         Anderson-Darling normality test
>
> data:  y3
> A = 273.668, p-value < 2.2e-16


## Generate 1000 log-normal random numbers and
## perform the Anderson-Darling test.
set.seed(403)
y4 = rlnorm(n, meanlog = 0, sdlog = 1)
ad.test(y4)

>         Anderson-Darling normality test
>
> data:  y4
> A = 91.4793, p-value < 2.2e-16


