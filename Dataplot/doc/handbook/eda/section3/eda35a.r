R commands and output:

## Read data and save batch as a factor.
m <- matrix(scan("gear.dat",skip=25),ncol=2,byrow=T)
diameter = m[,1]
batch = as.factor(m[,2])

## Attach "car" library and run Levene's test.
library(car)
levene.test(diameter, batch)

> Levene's Test for Homogeneity of Variance
>       Df F value  Pr(>F)  
> group  9  1.7059 0.09908 .
>       90                    
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

## Compute critical value.
qf(.95,9,90)

> [1] 1.985595