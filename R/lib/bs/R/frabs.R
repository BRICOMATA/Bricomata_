`frabs` <-
function(x,alpha=1.0,beta=1.0)
{
if(!is.numeric(x)||!is.numeric(alpha)||!is.numeric(beta)) 
stop ("non-numeric argument to mathematical function")
if(alpha<=0){stop("alpha must be positive")}
if(beta<=0){stop("beta must be positive")}
r<-rfbs(x,alpha,beta)
fra<-((-1)*log(r))/x
return(fra)
}

