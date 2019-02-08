`sicbs` <-
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
sic<-(-LogLik/n)+((p/2)*(log(n)/n))
return(sic)
}

