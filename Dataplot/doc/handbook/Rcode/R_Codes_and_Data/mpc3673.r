R commands and output:

## Read data and save relevant variables.
m = matrix(scan("calibrationline.dat"),ncol=5,byrow=T)
x = m[,1]
y = m[,2]

## Fit the linear calibration model and print the estimated
## coefficients.
z = lm(y ~ x)
zz = summary(z)
zz$coefficients

>              Estimate Std. Error    t value     Pr(>|t|)
> (Intercept) 0.2357623 0.02430034   9.702014 7.860745e-12
> x           0.9870377 0.00344058 286.881171 5.354121e-65

## print the covariance matrix.
v = vcov(z)
v

>               (Intercept)             x
> (Intercept)  5.905067e-04 -7.649453e-05
> x           -7.649453e-05  1.183759e-05

## Save model parameters and variances in convenient variables.
a = z$coef[1]
b = z$coef[2]
sa2 = v[1,1]
sb2 = v[2,2]
sab = v[1,2]
sy2 = zz$sigma^2

## Generate new Y' values for plotting.
ynew = seq(0,12,by=.25)

## Compute uncertainty for values of y.
u2 = sa2/b^2 + (ynew-a)^2*sb2/b^4 + sy2/b^2 + 2*(ynew-a)*sab/b^3
u = sqrt(u2)

## Plot uncertainty versus Y'.
plot(ynew,u,type="l",xlab="Instrument Response, micrometers",
     ylab="micrometers",
     main="Standard deviation of calibrated value X' for a given response Y'")