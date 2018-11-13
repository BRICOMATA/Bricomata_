R commands and output:

## Read data and save variables.
m <- matrix(scan("gear.dat",skip=25),ncol=2,byrow=T)
diameter = m[,1]
batch = as.factor(m[,2])

## Fit one-way anova model.
aov.out = aov(diameter ~ batch)
summary(aov.out)

>             Df   Sum Sq   Mean Sq F value Pr(>F)  
> batch        9 0.000729 8.100e-05   2.297 0.0227 *
> Residuals   90 0.003174 3.527e-05                 
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

## Output the residual standard deviation.
sqrt(sum(resid(aov.out)^2)/aov.out$df.resid)

> [1] 0.005938574

## Print the critical F value.
qf(0.95,9,90)

> [1] 1.985595

## Print the batch effects.
q = summary(lm(diameter~ batch-1))
q$coefficients[,1:2]

>         Estimate  Std. Error
> batch1    0.9980 0.001877942
> batch2    0.9991 0.001877942
> batch3    0.9954 0.001877942
> batch4    0.9982 0.001877942
> batch5    0.9919 0.001877942
> batch6    0.9988 0.001877942
> batch7    1.0015 0.001877942
> batch8    1.0004 0.001877942
> batch9    0.9983 0.001877942
> batch10   0.9948 0.001877942

