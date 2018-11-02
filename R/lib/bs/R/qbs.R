`qbs` <-
function(p,alpha=1.0,beta=1.0,lower.tail=TRUE,log.p=FALSE)
{
if(alpha<=0){stop("alpha must be positive")}
if(beta<=0){stop("beta must be positive")}
if(log.p==TRUE){p<-log(p)}
if(lower.tail==FALSE){p<-(1-p)}
q<-beta*(((alpha*qnorm(p,0,1)/2)+sqrt(((alpha*qnorm(p,0,1)/2)^2)+1)))^2
return(q)
}

