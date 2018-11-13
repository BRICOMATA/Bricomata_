R commands and output:

alpha = 0.05
m = 3
v = 38
zeta = .5*(1 - exp(log(1-alpha)/m))
TSTAR = qt(zeta, v, lower.tail=FALSE)
TSTAR

> [1] 2.497575