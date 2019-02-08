`beta1bs` <-
function(x)
{
if(!is.numeric(x)) 
{stop("non-numeric argument to mathematical function")}
parameter<-est1bs(x)
alpha<-parameter$alpha
beta<-parameter$beta
skewness<-(4*alpha*(6+(11*(alpha^2))))/((4+(5*(alpha^2)))^(3/2))
beta1<-(skewness)^2
return(beta1)
}

