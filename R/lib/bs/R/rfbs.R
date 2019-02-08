`rfbs` <-
function(x,alpha=1.0,beta=1.0)
{
if(!is.numeric(x)||!is.numeric(alpha)||!is.numeric(beta)) 
stop ("non-numeric argument to mathematical function")
if(alpha<=0){stop("alpha must be positive")}
if(beta<=0){stop("beta must be positive")}
x<-x
s<-(x/beta)
e<-(s^(1/2)-s^(-1/2))
z<-((1/alpha)*e)
cdf<-pnorm(z,0,1)
relia<-(1-cdf)
return(relia)
}

