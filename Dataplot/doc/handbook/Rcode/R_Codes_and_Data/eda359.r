R commands and output:

## Read data and save batch as a factor.
m <- matrix(scan("JAHANMI2.DAT",skip=50),ncol=16,byrow=T)
strength = m[,5]
batch = as.factor(m[,14])

## Perform F test.
var.test(strength~batch)

>         F test to compare two variances

> data:  strength by batch 
> F = 1.123, num df = 239, denom df = 239, p-value = 0.3704
> alternative hypothesis: true ratio of variances is not equal to 1 
> 95 percent confidence interval:
>  0.8709874 1.4480271 
> sample estimates:
> ratio of variances 
>           1.123038

## Find critical values for the F test.
qf(.025,239,239)

> [1] 0.7755639

qf(.975,239,239)

> [1] 1.289384