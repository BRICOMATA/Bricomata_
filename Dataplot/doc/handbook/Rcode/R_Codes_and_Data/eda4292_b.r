## R function by C.-M. Wang to compute the table value 
## for a prediction interval based on Table A.14 in 
## <a href="../section4/eda43.htm#Hahn">Hahn and Meeker (1991)</a>

ospi <- function(n, p, m, alpha, nrun=500000) {

## Compute the factor r for constructing one-sided
## (1 - alpha)*100% prediction intervals:
## xbar + r * s to contain at least p out of m 
## future observations based on a random sample 
## of size n from a normal distribution using a 
## Monte Carlo method with nrun Monte Carlo samples.
## Use alpha=0.05.

   z1 = rnorm(nrun)/sqrt(n)
   V = sqrt(rchisq(nrun, n-1)/(n-1))
   z2i = matrix(rnorm(m*nrun), byrow=T, ncol=m)
   xij = apply((z2i-z1)/V, 1, function(x, q) sort(x)[q], m-p+1)
   rval = quantile(xij, alpha)
   rval
}

## Example:  Compute a lower prediction interval 
## that contains each of three future observations.
## n=101, m=p=3, alpha=0.05

r = ospi(101,3,3,0.05)
r
##>        5% 
##> -2.160811 

xbar = 1400.91
sdx = 391.32
xbar + r*sdx
##>       5% 
##> 555.3414 