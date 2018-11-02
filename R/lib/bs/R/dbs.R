`dbs` <-
function(x,alpha=1.0,beta=1.0,log=FALSE)
{
if(!is.numeric(x)||!is.numeric(alpha)||!is.numeric(beta))
{stop("non-numeric argument to mathematical function")}
if(alpha<=0){stop("alpha must be positive")}
if(beta<=0){stop("beta must be positive")}
x<-x
c<-(1/sqrt(2*pi))
u<-(alpha^(-2))*((x/beta)+(beta/x)-2)
e<-exp((-1/2)*u)
du<-((x^(-3/2))*(x+beta))/(2*alpha*sqrt(beta))
pdf<-c*e*du
if(log==TRUE){pdf<-log(pdf)}
return(pdf)
}

