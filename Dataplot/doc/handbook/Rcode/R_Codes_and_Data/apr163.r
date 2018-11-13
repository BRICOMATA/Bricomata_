R commands and output:

## Define constants.
BET = 0.5
M = log(200000) 


## Load gamlss.dist package.
require(gamlss.dist)


## Calculate PDF and CDF values of the extreme value distribution
## corresponding to the points 5, 8, 10, 12, 12.8. 
X = c(5, 8, 10, 12, 12.8)


## Calculate PDF values.
PD = dGU(X, mu=M, sigma=BET)
PD

> [1] 1.101323e-06 4.442068e-04 2.396581e-02 6.830234e-01 2.468350e-01


## Calculate CDF values.
CD = pGU(X, mu=M, sigma=BET)
CD

> [1] 5.506615e-07 2.221281e-04 1.205587e-02 4.842990e-01 9.623731e-01


## Generate 100 random numbers from the extreme value distribution.
## (The type 1 extreme value distribution is sometimes called the
## Gumbel distribution.)
SAM= rGU(100, mu=M, sigma=BET)


## Load lattice package.
require(lattice)

## Generate extreme value probability plot.
qqmath (SAM, distribution = function(p) qGU(p),
        ylab="Sample Data", xlab="Theoretical Minimum")
