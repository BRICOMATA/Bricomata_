R commands and output:

## Input data and compute the cumulative hazard.
time = c( 37, NA, 73, NA, 132, 195, NA, 222, 248, NA)
fail = c(1, 0, 1, 0, 1, 1, 0, 1, 1, 0)
revrank = c(length(fail):1)
haz = fail/revrank
cumhaz = cumsum(haz)

## Select failing cases for plotting.
df = data.frame(time, fail, cumhaz)
z = subset(df, fail==1)

## Generate cumulative hazard plot for exponential distribution.
plot(z$time, z$cumhaz, type="o", pch=19, col="blue",
     xlab="Time", ylab="Cumulative Hazard",
     main="Exponential Distribution")

## Generate cumulative hazard plot for the Weibull distribution.
plot(z$time, z$cumhaz, type="o", pch=19, col="blue", log="xy",
     xlab="Time", ylab="Cumulative Hazard", 
     main="Weibull Distribution")

## Compute Weibull parameter estimates.
lm(log10(z$cumhaz)~log10(z$time))

##> Call:
##> lm(formula = log10(z$cumhaz) ~ log10(z$time))
##> 
##> Coefficients:
##>   (Intercept)  log10(z$time)  
##>        -3.025          1.271