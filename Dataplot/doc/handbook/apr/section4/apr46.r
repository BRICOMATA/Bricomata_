R commands and output:

## Example posterior gamma inverse CDF probabilities.
p09 = 1/qgamma(0.9, shape=4, scale=1/3309)
p09

##> [1] 495.3012

p08 = 1/qgamma(0.8, shape=4, scale=1/3309)
p08

##> [1] 599.995

p05 = 1/qgamma(0.5, shape=4, scale=1/3309)
p05

##> [1] 901.1289

p01 = 1/qgamma(0.1, shape=4, scale=1/3309)
p01

##> [1] 1896.526


## Generate data for plotting.
prob = seq(0.1,1,0.001)
obj = 1/qgamma(prob, shape=4, scale=1/3309)

## Plot posterior probabilities.
plot(obj,prob, type="l", xlab="MTBF Objective",
     ylab="Probability of Exceeding Objective",
     main="Posterior (after test) Gamma Distribution Plot")
abline(v=p09, col="blue")
abline(v=p08, col="blue")
abline(v=p05, col="blue")
abline(v=p01, col="blue")


## Compute the percentile for the reciprocal mean.
pgamma(4/3309, shape=4, scale=1/3309)

##> [1] 0.5665299
