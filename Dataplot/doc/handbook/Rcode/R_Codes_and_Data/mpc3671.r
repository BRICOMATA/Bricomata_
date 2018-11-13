R commands and output:

## Read data and save variables.
m = matrix(scan("loadcell.dat",skip=1),ncol=2,byrow=T)
x = m[,1]
y = m[,2]
x2 = x*x

## Generate quadratic regression curve and print results.
z = lm(y ~ x + x2)
zz = summary(z)
zz

> Call:
> lm(formula = y ~ x + x2)

> Residuals:
>        Min         1Q     Median         3Q        Max 
> -9.966e-05 -1.466e-05  5.944e-06  2.515e-05  5.595e-05 

> Coefficients:
>               Estimate Std. Error   t value Pr(>|t|)    
> (Intercept) -1.840e-05  2.451e-05    -0.751    0.459    
> x            1.001e-01  4.839e-06 20687.891   <2e-16 ***
> x2           7.032e-06  2.014e-07    34.922   <2e-16 ***
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

> Residual standard error: 3.764e-05 on 30 degrees of freedom
> Multiple R-squared:     1,      Adjusted R-squared:     1 
> F-statistic: 4.48e+09 on 2 and 30 DF,  p-value: < 2.2e-16 

## Print covariance matrix.
v = vcov(z)
v

>               (Intercept)             x            x2
> (Intercept)  6.006038e-10 -1.076163e-10  4.019870e-12
> x           -1.076163e-10  2.341301e-11 -9.506940e-13
> x2           4.019870e-12 -9.506940e-13  4.054636e-14

## Save coefficients and variances.
a = z$coef[1]
b = z$coef[2]
c = z$coef[3]
sa2 = v[1,1]
sb2 = v[2,2]
sc2 = v[3,3]
sy2 = zz$sigma**2

## Generate additional points on the x-axis for plotting.
xnew = seq(2,21,by=.1)
xnew2 = xnew^2
xp = data.frame(x=xnew,x2=xnew2)

## Predict response for given X' values.
yp = predict(z,new=xp)

## Generate calibration curve plot.
plot(x,y, main="Quadratic Calibration Curve for Load Cell 32066",
     xlab="Load, psi", ylab="Readings")
lines(xp$x,yp)
llab = paste("Y = ", round(a,7), " + ", round(b,7),
             "*X + ", round(c,7), "*X*X",sep="")
text(8,2,llab)
segments(x0=0,y0=1.344,x1=13.417,y1=1.344,lty=2,col="blue")
text(6,1.4, "Y'=1.344",col="blue")
segments(x0=13.417,y0=1.344,x1=13.417,y1=0,lty=2,col="blue")
text(15,0.6, "X'=13.417",col="blue")

## The equation for the quadratic calibration curve is:
## f = sqrt(-b + (b^2 - 4*c*(a-y)))/(2*c)
## The partial derivatives of f with respect to Y is:

dfdy = 1/sqrt(b^2 - 4*c*(a-y))

## The other partial derivatives are:

dfda = -1/sqrt(b^2 - 4*c*(a-y))

dfdb = (-1 + b/sqrt(b^2 - 4*c*(a-y)))/(2*c)

dfdc = (-4*a + 4*y)/(sqrt(b^2 - 4*c*(a-y))*(4*c)) - 
       (-b + sqrt(b^2 - 4*c*(a-y)))/(2*c^2)

## The standard deviation of X' is defined from propagation of error. 
u = sqrt(dfdy^2*sy2 + dfda^2*sa2 + dfdb^2*sb2 + dfdc^2*sc2)

## Plot uncertainty versus X'.
plot(y,u,type="n",xlab="Scale for Instrument Response",
     ylab="psi",
     main="Standard deviation of calibrated value X' for a given response Y'")
lines(spline(y,u))

## Print the covariance matrix for the loadcell data.
v

>               (Intercept)             x            x2
> (Intercept)  6.006038e-10 -1.076163e-10  4.019870e-12
> x           -1.076163e-10  2.341301e-11 -9.506940e-13
> x2           4.019870e-12 -9.506940e-13  4.054636e-14

## Save covariances.
sab = v[1,2]
sac = v[1,3]
sbc = v[2,3]

## Compute updated uncertainty.
unew = sqrt(u^2 + 2*dfda*dfdb*sab + 2*dfda*dfdc*sac + 2*dfdb*dfdc*sbc)

## Plot predicted value versus X'.
plot(y,unew,type="n",xlab="Scale for Instrument Response",
     ylab="psi",
     main="Standard deviation of calibrated value X' for a given response Y'")
lines(spline(y,unew))
