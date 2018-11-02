`aicbs` <-
function(x)
{
estimate<-est1bs(x)
alpha<-estimate$alpha
beta<-estimate$beta
n<-length(x)
p<-2
f<-dbs(x,alpha,beta)
l<-log(f)
LogLik<-sum(l)
aic<-(-LogLik/n)+(p/n)
return(aic)
}

