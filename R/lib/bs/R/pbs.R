`pbs` <-
function(q,alpha=1.0,beta=1.0,lower.tail=TRUE,log.p=FALSE)
{
if(!is.numeric(q)||!is.numeric(alpha)||!is.numeric(beta)) 
{stop("non-numeric argument to mathematical function")}
if(alpha<=0){stop("alpha must be positive")}
if(beta<=0){stop("beta must be positive")}
x<-q
s<-(x/beta)
a<-((1/alpha)*((s^(1/2))-(s^(-1/2))))
cdf<-pnorm(a,0,1)
if(lower.tail==FALSE){cdf<-(1-cdf)}
if(log.p==TRUE){cdf<-log(cdf)}
return(cdf)
}

