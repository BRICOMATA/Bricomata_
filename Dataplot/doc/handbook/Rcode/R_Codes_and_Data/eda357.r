R commands and output:

## Read data and save batch variable as a factor.
m <- matrix(scan("gear.dat",skip=25),ncol=2,byrow=T)
diameter = m[,1]
batch = as.factor(m[,2])

## Run Bartlett's test.
bartlett.test(diameter~batch)

>         Bartlett test of homogeneity of variances

> data:  diameter by batch 
> Bartlett's K-squared = 20.7859, df = 9, p-value = 0.01364

## Find critical value.
> qchisq(.95,9)

> [1] 16.91898
