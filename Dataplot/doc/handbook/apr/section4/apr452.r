R commands and output:

## Enter data.
x=c(5, 40, 43, 175, 389, 712, 747, 795, 1299, 1478 )
r=length(x)
T=1500


## Compute aHat, bHat, MTBF, ML, and MU.

BetaHat = 1-(r-1)/( sum(log(T/x)))
BetaHat

##> [1] 0.516494

aHat = r/(T^(1-BetaHat))
aHat

##> [1] 0.2913003

bHat = 1-BetaHat
bHat

##> [1] 0.483506

MTBF = T/(r*bHat)
MTBF

##> [1] 310.234


## Compute 80 % confidence interval for MTBF.
alpha = 0.2
za = qnorm(1-alpha/2)
za

##> [1] 1.281552

ML = MTBF*r*(r-1)/(r + (za^2)/4 + sqrt(r*(za^2)/2 + (za^4)/16))^2
ML

##> [1] 157.7138

MU = MTBF*r*(r-1)/(r - za*sqrt(r/2))^2
MU

##> [1] 548.5566