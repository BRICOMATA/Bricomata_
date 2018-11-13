R commands and output:

## Input temperature data, number of units, and cell data.
temp = c(85, 105, 125)
nu = c(100, 50, 25)
cell1 = c(401, 428, 695, 725, 738)
cell2 = c(171, 187, 189, 266, 275, 285, 301, 302, 305, 316, 317, 
          324, 349, 350, 386, 405, 480, 493, 530, 534, 536, 567, 
          589, 598, 599, 614, 620, 650, 668, 685, 718, 795, 854, 
          917, 926)
cell3 = c(24, 42, 92, 93, 141, 142, 143, 159, 181, 188, 194, 199, 
          207, 213, 243, 256, 259, 290, 294, 305, 392, 454, 502, 696)

## Apply ln function to cell data.
y1 = log(cell1)
y2 = log(cell2)
y3 = log(cell3)

## Generate lognormal probability plot using procedure from 8.2.2.1.
pos1 = 1:length(cell1)
pos2 = 1:length(cell2)
pos3 = 1:length(cell3)
pos1 = (pos1-0.3)/(nu[1]+0.4)
pos2 = (pos2-0.3)/(nu[2]+0.4)
pos3 = (pos3-0.3)/(nu[3]+0.4)
x1 = qnorm(pos1)
x2 = qnorm(pos2)
x3 = qnorm(pos3)

## Generate lognormal probability plot for each cell
## and plot the curves on the same plot.
plot(c(x1,x2,x3), c(y1,y2,y3), type="n", 
     xlab="Theoretical Quantiles", ylab="ln Time",
     main="PROBABILITY PLOT OF TEMPERATURE CELLS")    
lines(x1,y1, col="blue")
lines(x2,y2, col="blue")
lines(x3,y3, col="blue")

## Compute Ao, the ln T50 estimate, and A1, the cell sigma estimate.
z1 = lsfit(x1,y1)
z2 = lsfit(x2,y2)
z3 = lsfit(x3,y3)

## Save intercepts from the three fits. 
YARRH = c(z1$coef[1], z2$coef[1], z3$coef[1])
YARRH

> Intercept Intercept Intercept 
>  8.167866  6.415268  5.319294

## Compute 11605/(temp+273.16) for three cell temperatures.
XARRH = 11605/(temp + 273.15)
XARRH

> [1] 32.40262 30.68888 29.14731


## Plot Arrhenius cell T50's.
plot(XARRH, YARRH, type="o", ylab="ln T50", xlab="11605/(t+273.16)",
     main="ARRHENIUS PLOT", pch=19, col="red")

## Fit linear model.
z = lm( YARRH~XARRH, 
    weights=c(length(cell1), length(cell2), length(cell3)))
coef(z)

> (Intercept)       XARRH 
> -18.3113408   0.8084907 

## Estimate A.
A = exp(z$coef[1]) 
names(A) <- NULL
A

> (Intercept) 
>   1.115542e-08 

## Estimate delta H.
dH = z$coef[2]
names(dH) <- NULL
dH

> [1] 0.8084907

## Compute acceleration between 85 C and 125 C.
exp(dH*11605*(1/(temp[1]+273.16) - 1/(temp[3]+273.16)))

> [1] 13.89814

## Example of fitting a model with two stresses, 
## assuming Y, X1 ,X2  data vectors already exist. 
##lm(Y ~ X1 + X2)
