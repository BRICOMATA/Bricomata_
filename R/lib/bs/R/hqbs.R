`hqbs` <-
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
hqc<-(-LogLik/n)+(p*log(log(n))/n)
return(hqc)
}

