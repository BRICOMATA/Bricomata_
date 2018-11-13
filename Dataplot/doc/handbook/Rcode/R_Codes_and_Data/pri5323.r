R commands and output:

## Specify fitted models.
y1 = function (x) {
    return(-1*(35.4*x[1] + 42.77*x[2] + 70.36*x[3] + 16.02*x[1]*x[2] +
           36.33*x[1]*x[3] + 136.8*x[2]*x[3] + 854.9*x[1]*x[2]*x[3]))
}

y2 = function (x) {
    3.88*x[1] + 9.03*x[2] + 13.63*x[3] - 0.1904*x[1]*x[2] -
        16.61*x[1]*x[3] - 27.67*x[2]*x[3]
}

y3 = function (x) {
        23.13*x[1] + 19.73*x[2] + 14.73*x[3]}

## Attach Rsolnp library for the optimization.
require(Rsolnp)

## Define constraints.
eqc = function (x) {sum(x)}
eqc.b = 1

ineqc = function (x) {c(y2(x), y3(x))}
ineqc.ub = c(4.5, 20)
ineqc.lb = c(-Inf, -Inf)

x.lb = c(0, 0, 0)
x.ub = c(1, 1, 1)

## Run solnp to perform optimization.
os = solnp(pars=c(0.2, 0.2, 0.4), fun=y1, eqfun=eqc, eqB=eqc.b,
           ineqfun=ineqc, ineqLB=ineqc.lb, ineqUB=ineqc.ub,
           LB=x.lb, UB=x.ub)

## Print results.
x = os$pars
cbind(x, c(-y1(x), y2(x), y3(x)))

>  0.2123296 106.621508
>  0.3437247   4.176745
>  0.4439457  18.232192

## Test that the sum of the x variables is one.
sum(x)

> 1

