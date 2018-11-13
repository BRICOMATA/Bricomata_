R commands and output:

## Load the package containing special survival analysis functions.
require(survival)

## Create survival object.
failures = c(55, 187, 216, 240, 244, 335, 361, 373, 375, 386)
y = Surv(c(failures, rep(500, 10)), c(rep(1, length(failures)), rep(0, 10)))

## Fit survival data.
ys = survfit(y ~ 1, type="kaplan-meier")
summary(ys)

> Call: survfit(formula = y ~ 1, type = "kaplan-meier")
> 
>  time n.risk n.event survival std.err lower 95% CI upper 95% CI
>    55     20       1     0.95  0.0487        0.859        1.000
>   187     19       1     0.90  0.0671        0.778        1.000
>   216     18       1     0.85  0.0798        0.707        1.000
>   240     17       1     0.80  0.0894        0.643        0.996
>   244     16       1     0.75  0.0968        0.582        0.966
>   335     15       1     0.70  0.1025        0.525        0.933
>   361     14       1     0.65  0.1067        0.471        0.897
>   373     13       1     0.60  0.1095        0.420        0.858
>   375     12       1     0.55  0.1112        0.370        0.818
>   386     11       1     0.50  0.1118        0.323        0.775

## Generate Kaplan-Meier survival curve.
plot(ys, xlab="Hours", ylab="Survival Probability")

## Generate a Weibull probability plot.
p = ppoints(failures, a=0.3)
plot(failures, -log(1-p), log="xy", pch=19, col="red",
     xlab="Hours", ylab="Cumulative Hazard")

## Estimate parameters for Weibull distribution.
yw = survreg(y ~ 1, dist="weibull")
summary(yw)

> Call:
> survreg(formula = y ~ 1, dist = "weibull")
>              Value Std. Error     z         p
> (Intercept)  6.407      0.205 31.20 9.80e-214
> Log(scale)  -0.546      0.292 -1.87  6.15e-02
> 
> Scale= 0.58 
> 
> Weibull distribution
> Loglik(model)= -75.1   Loglik(intercept only)= -75.1
> Number of Newton-Raphson Iterations: 5 
> n= 20 

## Log-likelihood and Akaike's Information Criterion
signif(summary(yw)$loglik, 5)


> [1] -75.122 -75.122

signif(extractAIC(yw), 5)

> [1]   2.00 154.24

## Maximum likelihood estimates:
## For the Weibull model, survreg fits log(T) = log(eta) +
## (1/beta)*log(E), where E has an exponential distribution with mean 1
## eta = Characteristic life (Scale) 
## beta = Shape

etaHAT <- exp(coefficients(yw)[1])
betaHAT <- 1/yw$scale
signif(c(eta=etaHAT, beta=betaHAT), 6)

> eta.(Intercept)            beta 
>       606.00500         1.72563 

## Lifetime: expected value and standard deviation.
muHAT = etaHAT * gamma(1 + 1/betaHAT)
sigmaHAT = etaHAT * sqrt(gamma(1+2/betaHAT) - (gamma(1+1/betaHAT))^2)
names(muHAT) = names(sigmaHAT) = names(betaHAT) = names(etaHAT) = NULL
signif(c(mu=muHAT, sigma=sigmaHAT), 6)

>      mu   sigma 
> 540.175 322.647

## Probability density of fitted model.
curve(dweibull(x, shape=betaHAT, scale=etaHAT),
      from=0, to=muHAT+6*sigmaHAT, col="blue",
      xlab="Hours", ylab="Probability Density")

## Weibull versus lognormal models.
yl = survreg(y ~ 1, dist="lognormal")
signif(c(lognormalAIC=extractAIC(yl)[2], weibullAIC=extractAIC(yw)[2]), 5)

> lognormalAIC   weibullAIC 
>       154.33       154.24
