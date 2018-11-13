R commands and output:

## Read data.
diameter <- scan("lew.dat",skip=25)

## Attach "lawstat" library and peform runs test.
library(lawstat)
runs.test(diameter,alternative="two.sided")

>         Runs Test - Two sided

> data:  diameter 
> Standardized Runs Statistic = 2.6938, p-value = 0.007065

## Compute critical value.
qnorm(.975)

> [1] 1.959964

