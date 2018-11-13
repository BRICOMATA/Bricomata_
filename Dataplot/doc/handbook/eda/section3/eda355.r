R commands and output:

## Read data and save variables as factors.
m <- matrix(scan("JAHANMI2.DAT",skip=50),ncol=16,byrow=T)
strength = m[,5]
speed = as.factor(m[,6])
feedrate = as.factor(m[,7])
grit = as.factor(m[,8])
batch = as.factor(m[,14])

## Fit the model and print the anova table.
fit.lm = lm(strength ~ speed + feedrate + grit + batch)
summary.aov(fit.lm)

>              Df  Sum Sq Mean Sq  F value    Pr(>F)    
> speed         1   26673   26673   6.7081  0.009892 ** 
> feedrate      1   11524   11524   2.8983  0.089327 .  
> grit          1   14380   14380   3.6164  0.057818 .  
> batch         1  727138  727138 182.8690 < 2.2e-16 ***
> Residuals   475 1888731    3976                       
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1  

## Print effect estimates.
summary(fit.lm)

> Call:
> lm(formula = strength ~ speed + feedrate + grit + batch)

> Residuals:
>      Min       1Q   Median       3Q      Max 
> -309.784  -31.082    3.651   34.923  203.617 

> Coefficients:
>             Estimate Std. Error t value Pr(>|t|)    
> (Intercept)  697.027      6.436 108.305   <2e-16 ***
> speed1       -14.909      5.756  -2.590   0.0099 ** 
> feedrate1      9.800      5.756   1.702   0.0893 .  
> grit1        -10.947      5.756  -1.902   0.0578 .  
> batch2       -77.843      5.756 -13.523   <2e-16 ***
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

> Residual standard error: 63.06 on 475 degrees of freedom
> Multiple R-squared: 0.2922,     Adjusted R-squared: 0.2862 
> F-statistic: 49.02 on 4 and 475 DF,  p-value: < 2.2e-16