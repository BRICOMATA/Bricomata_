R commands and output:


## Initalize constants.
alpha=0.10
nd = 4
n = 20

## Define functions for upper and lower limits
## for a 90 % confidence interval.
fl = function(p){pbinom(nd-1,n,p) - (1-alpha/2)}
fu = function(p){pbinom(nd,n,p) - alpha/2}

## Find the roots of the functions.
pl = uniroot(fl,c(.01,.99))
pl$root

> [1] 0.07134838

pu = uniroot(fu,c(.01,.99))
pu$root

> [1] 0.4010294
