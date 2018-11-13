R commands and output:

## Input data.
x = c(-1.40, -0.44, -0.30, -0.24, -0.22, -0.13, -0.05,
       0.06, 0.10, 0.18, 0.20, 0.39, 0.48, 0.63, 1.01)

## Specify k, the number of outliers being tested.
k = 2

## Generate normal probability plot.
qqnorm(x)

## Create a function to compute statistic to
## test for outliers in both tails.
tm = function(x,k){

n = length(x)

## Compute the absolute residuals.
r = abs(x - mean(x))

## Sort data according to size of residual.
df = data.frame(x,r)
dfs = df[order(df$r),]

## Create a subset of the data without the largest k values.
klarge = c((n-k+1):n)
subx = dfs$x[-klarge]

## Compute the sums of squares.
ksub = (subx - mean(subx))**2
all = (df$x - mean(df$x))**2

## Compute the test statistic.
ek = sum(ksub)/sum(all)
}

## Call the function and compute value of test statistic for data.
ekstat = tm(x,k)
ekstat

> [1] 0.2919994

## Compute critical value based on simulation.
test = c(1:10000)
for (i in 1:10000){
xx = rnorm(length(x))
test[i] = tm(xx,k)}
quantile(test,0.05)

>        5% 
> 0.3150342
