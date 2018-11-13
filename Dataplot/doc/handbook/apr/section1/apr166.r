R commands and output:

##  Load VGAM package.
require(VGAM)

## Define constants gamma and mu.
mu = 5000
gamma = 2
t = 4000

## Compute the PDF at t=4000.
PDF = dbisa(t, shape=gamma, scale=mu)
PDF

> [1] 4.986585e-05


## Compute the CDF.
CDF = pbisa(t, shape=gamma, scale=mu)
CDF

> [1] 0.4554896


## Generate 100 random numbers from the Birnbaum-Saunders
## distribution.
data.bs= rbisa (100, shape=2, scale=5000)


## Load lattice package for probability plot.
require(lattice)

## Generate probability plot.
qqmath(data.bs, distribution=function(p) qbisa(p, shape=2),
       ylab="Time", xlab="Expected Value")


## Functions to estimate scale and shape parameters from data.
harmon=function(x) {1/(mean(1/x))}
scale.mm = function(y) {sqrt(mean(y)*harmon(y))}
shape.mm= function(y) {sqrt(2*sqrt(mean(y)/harmon(y))-1)}

## Calculate shape parameter.
shape.est=shape.mm(data.bs)
shape.est

> [1] 2.109786

## Calculate scale parameter.
scale.mm(data.bs)

> [1] 5593.329

## Generate probability plot.
qqmath(data.bs, distribution=function(p) qbisa(p, shape=shape.est))



