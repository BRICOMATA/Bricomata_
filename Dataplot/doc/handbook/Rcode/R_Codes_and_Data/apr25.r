R commands and output:

## Set the reasonable MTBF, the low MTBF, and 
## calculate their ratio RT.
MTBF50 = 600
MTBF05 = 250
RT = MTBF50/MTBF05

## Find gamma prior parameter "a" so that the ratio
## qgamma(0.95,a,1)/qgamma(0.5,a,1) equals the RT

estimating_a = function(a)
{
 return(qgamma(0.95,a,1)/qgamma(0.5,a,1)-RT)
}
A = uniroot(estimating_a, c(0.001,500), tol = .Machine$double.eps)
a = A[1]$root
a

##> [1] 2.863055

## (3) Find gamma prior parameter b
b = 0.5*MTBF50*qgamma(0.5,a,1/2)
b

##> [1] 1522.506

## Check probabilities.
pgamma(.001667,shape=2.863,scale=1/1522.46)

##> [1] 0.5001232

pgamma(.004,shape=2.863,scale=1/1522.46) 

##> [1] 0.9499963