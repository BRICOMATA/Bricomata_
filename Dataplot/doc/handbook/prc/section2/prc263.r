R commands and output:


## Compute the approximate and exact k2 factor.

## Compute the approximate k2 factor for a two-sided tolerance interval. 
## For this example, the standard deviation is computed fromt the sample,
## so the degrees of freedom are nu = N - 1.
N = 43
nu = N - 1
p = 0.90
g = 0.99
z2 = (qnorm((1+p)/2))**2
c2 = qchisq(1-g,nu)
k2 = sqrt(nu*(1 + 1/N)*z2/c2)
k2

##> [1] 2.217316


## Compute the exact k2 factor for a two-sided tolerance interval using 
## the K.factor function in the tolerance library
library(tolerance)
K2 = K.factor(n=N, f=nu, alpha=((1+p)/2), P=g, side=2, method="EXACT", m=100)
K2

##> [1] 2.210167


## "Direct" calculation of a tolerance interval.

## Read data and name variables.
m = read.table(100ohm.dat)
colnames(m) = c("cr", "wafer", "mo", "day", "h", "min", "op", 
                 "hum", "probe", "temp", "y", "sw", "df")

## Attach tolerance library and call function.
library(tolerance)
normtol.int(m$y, alpha=0.01, P=.90, side=2)

>   alpha   P    x.bar 2-sided.lower 2-sided.upper
> 1  0.01 0.9 97.06984      97.00273      97.13695


## Calculate the k factor for a one-sided tolerance interval.

n = 43
p = 0.90
g = 0.99
nu = n-1
zp = qnorm(p)
zg = qnorm(g)
a = 1 - ((zg**2)/(2*nu))
b = zp**2 - (zg**2)/n
k1 = (zp + (zp**2 - a*b)**.5)/a
c(a,b,k1)

> [1] 0.9355727 1.5165164 1.8751896


## Tolerance factor based on the non-central t distribution.

n = 43
p = .90
g = .99
f = n - 1
delta = qnorm(p)*sqrt(n)
k = qt(g,f,delta)/sqrt(n)
k

> [1] 1.873954
