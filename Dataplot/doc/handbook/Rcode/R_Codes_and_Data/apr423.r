R commands and output:

## Input data.
DEG = c(0.87, 0.33, 0.94, 0.72, 0.66, 1.48, 0.96, 2.91, 1.98, 
       0.99, 2.81, 2.13, 5.67, 4.28, 2.14, 1.41, 3.61, 2.13,
       4.36, 6.91, 2.47, 8.99, 5.72, 9.82, 17.37, 5.71, 17.69,
       11.54, 19.55, 34.84, 24.58, 9.73, 4.74, 23.61, 10.90,
       62.02, 24.07, 11.53, 58.21, 27.85, 124.10, 48.06, 
       23.72, 117.20, 54.97)

TEMP = c(rep(65,15), rep(85,15), rep(105,15))

TIME = rep(c(200, 200, 200, 200, 200, 
             500, 500, 500, 500, 500, 
             1000, 1000, 1000, 1000, 1000), 3)

## Create variables for fitting.
YIJK = log(30) - (log(DEG) - log(TIME)) 
XIJK = 100000/(8.617*(TEMP + 273.16)) 

## Fit model.
lin.fit= lm(YIJK ~ XIJK)
summary(lin.fit)

> Call:
> lm(formula = YIJK ~ XIJK)
> 
> Residuals:
>      Min       1Q   Median       3Q      Max 
> -0.82806 -0.39392 -0.04028  0.35714  1.12534 
> 
> Coefficients:
>              Estimate Std. Error t value Pr(>|t|)    
> (Intercept) -18.94337    1.83343  -10.33 3.17e-13 ***
> XIJK          0.81877    0.05641   14.52  < 2e-16 ***
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
> 
> Residual standard error: 0.5611 on 43 degrees of freedom
> Multiple R-squared: 0.8305,     Adjusted R-squared: 0.8266 
> F-statistic: 210.7 on 1 and 43 DF,  p-value: < 2.2e-16 
