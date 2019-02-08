`est3bs` <-
function(x)
{
if(!is.numeric(x)) 
stop ("non-numeric argument to mathematical function")
n<-length(t<-x)
s<-(1/n)*sum(t)
r<-((1/n)*sum(t^(-1)))^(-1)
alpha<-sqrt(2*((sqrt(s/r))-1))
beta<-sqrt(s*r)
listbs<-list(alpha=alpha,beta=beta)
return(listbs)
}

