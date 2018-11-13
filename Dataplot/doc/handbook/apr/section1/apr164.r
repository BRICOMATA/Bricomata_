R commands and output:

## Define constants.
T = 5000
sigma = 0.5
T50 = 20000


## Find PDF values.
PDF = dlnorm(T,sdlog=sigma, meanlog=log(T50))
PDF

> [1] 3.417475e-06


## Find CDF values.
CDF = plnorm(T,sdlog=sigma, meanlog=log(T50))
CDF

> [1] 0.002780618


## Find failure rate.
HAZ = dlnorm(T, sdlog=sigma, 
      meanlog=log(T50))/(1-plnorm(T,sdlog=sigma, meanlog=log(T50)))
HAZ

> [1] 3.427004e-06


## Generate 100 lognormal random numbers for probability plot.
sample=rlnorm(100, meanlog=log(20000), sdlog=0.5)


## Generate lognormal probability plot.
require(lattice)
qqmath(sample, distribution=function(p) qlnorm(p,sdlog=0.5),
       ylab="TIME", xlab="EXPECTED (NORMALIZED) VALUES" ,type="l")


## Generate lognormal probability plot when sigma is estimated from data.
logsamp = log(sample)
SD.est = sd(logsamp)
qqmath(sample, distribution=function(p) qlnorm(p,sdlog=SD.est),
       ylab="TIME", xlab="EXPECTED (NORMALIZED) VALUES", type="l")