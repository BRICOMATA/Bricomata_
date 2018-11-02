`delta2bs` <-
function(x)
{
if(!is.numeric(x)) 
{stop("non-numeric argument to mathematical function")}
parameter<-est1bs(x)
alpha<-parameter$alpha
beta<-parameter$beta
calculus<-(((5*(alpha^4))+(4*(alpha^2)))/(((alpha^2)+2)^2))
delta2<-calculus
return(delta2)
}

