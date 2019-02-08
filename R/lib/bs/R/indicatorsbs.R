`indicatorsbs` <-
function(x)
{
if(!is.numeric(x)) 
{stop("non-numeric argument to mathematical function")}
parameter<-est1bs(x)
alpha<-parameter$alpha
beta<-parameter$beta
mean<-beta*(1+((1/2)*alpha))
variance<-(alpha^2)*(beta^2)*(1+((5/4)*(alpha^2)))
variation<-(alpha*sqrt(4+(5*(alpha^2))))/(2+(alpha^2))
skewness<-(4*alpha*(6+(11*(alpha^2))))/((4+(5*(alpha^2)))^(3/2))
kurtosis<-3+((6*(alpha^2)*((93*(alpha^2))+40))/(((5*(alpha^2))+4))^(2))
cat("Alpha = ", alpha, "\n")
cat("Beta  = ", beta, "\n")
cat("Mean     = ", mean, "\n")
cat("Variance = ", variance, "\n")
cat("Variation coefficient = ", variation, "\n")
cat("Skewness coefficient = ", skewness, "\n")
cat("Kurtosis coefficient = ", kurtosis, "\n")
}

