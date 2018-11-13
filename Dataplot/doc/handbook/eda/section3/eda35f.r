R commands and output:

## Attach the "nortest" library that contains the chi-square test.
library(nortest)
n=1000


## Generate normal random numbers and perform the chi-square test.
y1 = rnorm(n, mean = 0, sd = 1)
pearson.test(y1)

>         Pearson chi-square normality test
>
> data:  y1 
> P = 32.256, p-value = 0.3087


## Generate double exponential random numbers and perform
## the chi-square test.
y2 = ifelse(runif(n) > 0.5, 1, -1) * rexp(n) 
pearson.test(y2)

>         Pearson chi-square normality test
>
> data:  y2 
> P = 91.776, p-value = 1.935e-08


## Generate t random numbers and perform the chi-square test.
y3 = rt(n, 3)
pearson.test(y3)

>         Pearson chi-square normality test
>
> data:  y3 
> P = 101.488, p-value = 5.647e-10


## Generate lognormal random numbers and perform the chi-square test.
y4 = rlnorm(n, meanlog = 0, sdlog = 1)
z = pearson.test(y4)
z

>         Pearson chi-square normality test
>
> data:  y4 
> P = 1085.104, p-value < 2.2e-16


## Compute critical value.
qchisq(.05,z$n.classes-3,lower.tail=FALSE)

##> [1] 42.55697

