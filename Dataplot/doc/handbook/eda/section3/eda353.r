R commands and output:

## Read data and save variables.
y <- matrix(scan("auto83b.dat",skip=25),ncol=2,byrow=T)
usmpg = y[,1]
jmpg  = y[,2]
jmpg  = jmpg[jmpg!=-999]

## Perform two-sample t-test.
z = t.test(usmpg,jmpg,var.equal=TRUE)

> Case 1:  Equal Variances
>
>         Two Sample t-test
>
> data:  usmpg and jmpg 
> t = -12.6206, df = 326, p-value < 2.2e-16
> alternative hypothesis: true difference in means is not equal to 0 
> 95 percent confidence interval:
>  -11.947653  -8.725216 
> sample estimates:
> mean of x mean of y 
>  20.14458  30.48101 

## Find one-tailed and two-tailed critical values.
qt(.05,z$parameter)

> -1.649541

qt(.025,z$parameter)

> [1] -1.967268




