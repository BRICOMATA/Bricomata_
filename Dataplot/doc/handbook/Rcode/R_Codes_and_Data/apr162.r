R commands and output:

## Evaluate the PDF a Weibull distribution with 
## T=1000, gamma=1.5, and alpha=5000.
T = 1000
gamma = 1.5 
alpha = 5000
dweibull(T, gamma, alpha)

##> [1] 0.0001226851


## Evaluate the CDF a Weibull distribution with T=1000, 
## gamma=1.5, and alpha=5000.
pweibull(T, gamma, alpha)

##> [1] 0.08555936

## Generate 100 random numbers from a Weibull with shape parameter 
## gamma=1.5 and characteristic life alpha=5000.
sample = rweibull(100, 1.5, 5000)


## The Weibull probability plot is not available directly in R. However, 
## the plot can be created using the formula -ln(1 - p) for the percentiles
## and plotting on a log-log scale.

## Generate a Weibull probability plot for the data generated.
p = ppoints(sort(sample), a=0.3)
plot(sort(sample), -log(1-p), log="xy", type="o", col="blue",
     xlab="Time", ylab="ln(1/(1-F(t)))",
     main = "Weibull Q-Q Plot")
