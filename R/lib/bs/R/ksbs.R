`ksbs` <-
function(x,alternative=c("less","two.sided","greater"),plot=FALSE)
{
estimate<-est1bs(x)
alpha<-estimate$alpha
beta<-estimate$beta
res<-ks.test(x,pbs,alpha,beta,alternative=alternative)
if(plot==TRUE)
{
plot(ecdf(x),do.points=FALSE,main="",xlab='t',ylab='Fn(t)')
mini<-min(x)
maxi<-max(x)
t<-seq(mini,maxi,by=0.01)
y<-pbs(t,alpha,beta)
lines(t,y,lwd=2)
}
return(res)
}

