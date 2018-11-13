R commands and output:

## Input data and create variables.
m <- matrix(scan("splett3.dat",skip=25),ncol=5,byrow=T)
y  = m[,1]
x1 = m[,2]
x2 = m[,3]
x3 = m[,4]

## Compute the pseudo-replication standard deviation 
## (assuming all 3rd order and higher interactions are 
## really due to random error).
z = lm(y ~ 1 + x1 + x2 + x3 + x1*x2 + x1*x3 + x2*x3)
summary(z)$sigma

> [1] 0.2015254

## Compute the standard deviation of a coefficient based 
## on the pseudo-replication standard deviation.
summary(z)$coefficients[2,2]

> [1] 0.07125

## Save t-values based on pseudo-replication standard deviation.
t1 = summary(z)$coefficients[2,3]
t2 = summary(z)$coefficients[3,3]
t23 = summary(z)$coefficients[7,3]
t13 = summary(z)$coefficients[6,3]
t3 = summary(z)$coefficients[4,3]
t123 = 1
t12 = summary(z)$coefficients[5,3]
Tvalue = round(rbind(NaN,t1,t2,t23,t13,t3,t123,t12),2)

## Compute the effect estimate and residual standard deviation
## for each model (mean plus the effect).

z = lm(y ~ 1)
mean = summary(z)$coefficients[1]
ese = summary(z)$sigma

z = lm(y ~ 1 + x1)
e1 = 2*summary(z)$coefficients[2]
e1se = summary(z)$sigma

z = lm(y ~ 1 + x2)
e2 = 2*summary(z)$coefficients[2]
e2se = summary(z)$sigma

z = lm(y ~ 1 + x2:x3)
e23 = 2*summary(z)$coefficients[2]
e23se = summary(z)$sigma

z = lm(y ~ 1 + x1:x3)
e13 = 2*summary(z)$coefficients[2]
e13se = summary(z)$sigma

z = lm(y ~ 1 + x3)
e3 = 2*summary(z)$coefficients[2]
e3se = summary(z)$sigma

z = lm(y ~ 1 + x1:x2:x3)
e123 = 2*summary(z)$coefficients[2]
e123se = summary(z)$sigma

z = lm(y ~ 1 + x1:x2)
e12 = 2*summary(z)$coefficients[2]
e12se = summary(z)$sigma

Effect = rbind(mean,e1,e2,e23,e13,e3,e123,e12)
Eff.SE = rbind(ese,e1se,e2se,e23se,e13se,e3se,e123se,e12se)

## Compute the residual standard deviation for cumulative
## models (mean plus cumulative terms).

z = lm(y ~ 1)
ce = summary(z)$sigma
z = lm(y ~ 1 + x1)
ce1 = summary(z)$sigma
z = lm(y ~ 1 + x1 + x2)
ce2 = summary(z)$sigma
z = lm(y ~ 1 + x1 + x2 + x2:x3)
ce3 = summary(z)$sigma
z = lm(y ~ 1 + x1 + x2 + x2:x3 + x1:x3)
ce4 = summary(z)$sigma
z = lm(y ~ 1 + x1 + x2 + x2:x3 + x1:x3 + x3)
ce5 = summary(z)$sigma
z = lm(y ~ x1 + x2 + x2:x3 + x1:x3 + x3 + x1:x2:x3)
ce6 = summary(z)$sigma
z = lm(y ~ 1 + x1*x2*x3)
ce7 = summary(z)$sigma

Cum.Eff = rbind(ce,ce1,ce2,ce3,ce4,ce5,ce6,ce7)

## Combine the results into a dataframe.
round(data.frame(Effect, Tvalue, Eff.SE, Cum.Eff),5)

>        Effect Tvalue  Eff.SE Cum.Eff
> mean  2.65875    NaN 1.74106 1.74106
> e1    3.10250  21.77 0.57272 0.57272
> e2   -0.86750  -6.09 1.81264 0.30429
> e23   0.29750   2.09 1.87270 0.26737
> e13   0.24750   1.74 1.87513 0.23341
> e3    0.21250   1.49 1.87656 0.19121
> e123  0.14250   1.00 1.87876 0.18031
> e12   0.12750   0.89 1.87912     NaN
