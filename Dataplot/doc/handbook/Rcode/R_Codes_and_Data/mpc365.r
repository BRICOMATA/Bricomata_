R commands and output:

## Read the data and define variables.
m = matrix(scan("loadcell.dat",skip=2),ncol=2,byrow=T)
y = m[,2]
x = m[,1]
x2 = x^2

## Fit the quadratic model.
z = lm(y ~ x + x2)
summary(z)

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

## Perform lack-of-fit test.
lof = lm(y~factor(x))

## Print results.
anova(z,lof)

> Analysis of Variance Table

> Model 1: y ~ x + x2
> Model 2: y ~ factor(x)
>   Res.Df        RSS Df  Sum of Sq      F Pr(>F)
> 1     30 4.2504e-08                            
> 2     22 3.7733e-08  8 4.7700e-09 0.3477 0.9368



