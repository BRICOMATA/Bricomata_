R commands and output:

## Input data and generate plotting variables.
## x = time of failure
## y = ln(1/(1-F(t))
x = c(54, 187, 216, 240, 244, 335, 361, 373, 375, 386)
n = 20
fnum = c(1:length(x))
Ft = (fnum-0.3)/(n+0.4)
y = log(1/(1-Ft))

## Print y values.
y
> [1] 0.03491627 0.08701138 0.14197026 0.20012618 0.26187419 0.32768741
> [7] 0.39813907 0.47393291 0.55594606 0.64529116

## Generate probability plot.
plot(x,y, xlab="Time", ylab="ln(1/(1-F(t)))", log="xy",
     type="o", pch=19, col="blue")

## Compute slope of line fit to plotted data.
xx=log10(x)
yy=log10(y)
z = lm(yy ~ xx)
coef(z)

>(Intercept)          xx 
>  -4.116536    1.457519 

## Another way to generate the Weibull Probability Plot using
## functions already available in R.
p = ppoints(x, a=0.3)
plot(x, -log(1-p), log="xy", type="o", col="blue",
     xlab="Time", ylab="ln(1/(1-F(t)))")
