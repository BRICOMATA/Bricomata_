R commands and output:

## There are two ways to specify the Weibull
## distribution function.

## (1)
Y = pweibull(800*5, 1.5, 8000)

> [1] 0.2978115

## (2)

Y = pweibull((800*5)/8000,shape=1.5)  

> [1] 0.2978115