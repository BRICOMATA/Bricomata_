`crfbs` <-
function(t,x=0,alpha=1.0,beta=1.0)
{
if(!is.numeric(t)||!is.numeric(x)||!is.numeric(alpha)||!is.numeric(beta)) 
stop ("non-numeric argument to mathematical function")
if(alpha<=0){stop("alpha must be positive")}
if(beta<=0){stop("beta must be positive")}
t<-t
x<-x
nume<-rfbs(t+x,alpha,beta)
deno<-rfbs(x,alpha,beta)
cr<-(nume/deno)
return(cr)
}

