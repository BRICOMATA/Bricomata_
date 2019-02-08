`rbs2` <-
function(n,alpha=1.0,beta=1.0)
{
if(!is.numeric(n)||!is.numeric(alpha)||!is.numeric(beta)) 
{stop("non-numeric argument to mathematical function")}
if(n<=0){stop("value of n must be greater or equal then 1")}
if(alpha<=0){stop("alpha must be positive")}
if(beta<=0){stop("beta must be positive")}
z<-rnorm(n,0,1)
t<-beta*(1+(((alpha^2)*(z^2))/2)+(alpha*z*sqrt((((alpha^2)*(z^2))/4)+1)))
return(t)
}

