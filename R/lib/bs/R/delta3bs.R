`delta3bs` <-
function(x)
{
if(!is.numeric(x)) 
{stop("non-numeric argument to mathematical function")}
parameter<-est1bs(x)
alpha<-parameter$alpha
beta<-parameter$beta
calculus<-((44*(alpha^4))+(24*(alpha^2)))/(((5*(alpha^2))+4)*((alpha^2)+2))
delta3<-calculus
return(delta3)
}

