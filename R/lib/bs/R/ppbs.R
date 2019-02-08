`ppbs` <-
function(x,line=FALSE,
xlab='Empirical distribution function',
ylab='Theorical distribution function'){
estimate<-est1bs(x)
alpha<-estimate$alpha
beta<-estimate$beta
F<-pbs(x,alpha,beta)
Pemp<-sort(F)
n<-length(x)
k<-seq(1,n,by=1)
Pteo<-(k-0.5)/n
plot(Pemp,Pteo,xlab=xlab,ylab=ylab,col=4,xlim=c(0,1),ylim=c(0,1),lwd=2)
if(line==TRUE)
{
lines(c(0,1),c(0,1),col=2,lwd=2)
}
r<-cor(Pemp,Pteo)
R<-(r^2)*100
listbspp<-list(alpha=alpha,beta=beta,DC=R)
return(listbspp)
}

