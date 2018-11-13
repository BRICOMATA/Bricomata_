R commands and output:

## Input failure times.
x = c(5, 40, 43, 175, 389, 712, 747, 795, 1299, 1478)
nfail = length(x)

## Cumulative plot.
plot(x,1:nfail, xlim=c(0,1500), main="Cumulative Plot", 
     xlab="System Age", ylab="No. Repairs", 
     type="o", col="blue", pch=19)

## Compute interarrival time.
x0 = c(0, x[1:(length(x)-1)])
interarrival = x-x0

## Interarrival time plot.
plot(1:nfail, interarrival, xlab="Failure Number", 
     ylab="Interarrival Time",
     main = "Interarrival Time versus Failure Number", 
     col="red", pch=17)

## Reciprocal interarrival time plot.
plot(1:nfail, 1/interarrival, xlab="Failure Number",
     ylab="Reciprocal Interarrival Time", 
     main="Reciprocal Interarrival Times",
     col="blue", pch=19)

## Duane plot.
MCUM = x / (1:nfail)
plot(x, MCUM, log="xy", xlab="Failure Time",
     ylab="Cumulative Hazard",
     main="Duane Plot", 
     col="red", pch=18,
     panel.first=grid(equilogs=FALSE)) 
