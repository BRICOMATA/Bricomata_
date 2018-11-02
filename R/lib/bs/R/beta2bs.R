`beta2bs` <-
function(x)
{
if(!is.numeric(x)) 
{stop("non-numeric argument to mathematical function")}
parameter<-est1bs(x)
alpha<-parameter$alpha
beta<-parameter$beta
kurtosis<-3+((6*(alpha^2)*((93*(alpha^2))+40))/(((5*(alpha^2))+4))^(2))
beta2<-kurtosis
return(beta2)
}

