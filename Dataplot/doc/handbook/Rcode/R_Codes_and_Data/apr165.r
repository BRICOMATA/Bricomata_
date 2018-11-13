R commands and output:

## Define constants.
## Shape = alpha = a.
## Scale = beta (b = 1/beta).
t = 24
a = 2
beta = 30


## Calculate PDF value.
pdf1 = dgamma(t, shape=a, scale=beta)
pdf1

##> [1] 0.01198211


## Calculate CDF value.
cdf1 = pgamma(t, shape=a, scale=beta)
cdf1

##> [1] 0.1912079
  

## Calculate reliability.
REL = 1-cdf1
REL

##> [1] 0.8087921

## Calculate failure rate.
FR = pdf1/REL
FR

##> [1] 0.01481481
  

## Generate 100 Gamma random numbers.
data1 = rgamma(100, shape=a, scale=beta)


## Load lattice library for plotting.
require(lattice)


## Generate probability plot.
qqmath(data1,distribution=function(p) qgamma(p, shape=2),  
       ylab="TIME" ,xlab="EXPECTED (NORMALIZED) VALUES")


## The value of the shape parameter gamma can be 
## estimated with a method of moments estimator.
shape.est = (mean(data1)/sd(data1))^2
qqmath(data1, distribution=function(p) qgamma(p, shape=shape.est),  
       ylab="TIME" ,xlab="EXPECTED (NORMALIZED) VALUES")
