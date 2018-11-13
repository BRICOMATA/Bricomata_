R commands and output:


## Example 1

## Create variables.
failnum = c(1:8)
age = c(33,76,145,347,555,811,1212,1499)
MTBF = age/failnum

## Generate Duane plot.
plot(age, MTBF, log = "xy", xaxt="n", yaxt="n", pch=19,
     col="blue", xlab="System Age", ylab="Cumulative MTBF") 
axis(1, at=(seq(0,10000,100)))
axis(2, at=(seq(0,200,10)))


## Example 2

## A function to generate 13 random repair times 
## and plot the results follows.
## The user provides N, a, and b.

powersim=function(N,a,b){

U=runif(N)

Y= rep(NA,N)

Y[1]= ((-1/a)* log(U[1]) ) ^(1/b)

for ( i in 2:N){
  Y[i]= ( (Y[i-1])^b - (1/a)* (log(U[i]) ) )^ (1/b) 
}

plot(Y, 1:N,xlab="Failure Times", ylab="Failure Number")

return(list(Y = Y))}


## Run the function.
ex = powersim(13,.2,.4)

ex$Y

>  [1]     7.129044    62.825997    79.998949   456.669847   600.635556
>  [6]   982.997682  5892.529347  6242.845270  7786.899615 10462.573861
> [11] 11941.892215 12570.738837 25737.514277


## Generate Duane plot.
FAILNUM = 1:13
FAILTIME = ex$Y
MCUM = FAILTIME/FAILNUM 

plot(log10(FAILTIME),log10(MCUM), xlab='log10(Failure Time)', 
     ylab='log10 (Cum MTBF)')


