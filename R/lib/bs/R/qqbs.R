`qqbs` <-
function(x,line=FALSE,
xlab='Empirical quantiles',ylab='Theoretical quantiles')
{
estimate<-est1bs(x)
alpha<-estimate$alpha
beta<-estimate$beta
n<-length(x)
k<-seq(1,n,by=1)
P<-(k-0.5)/n
Finv<-qbs(P,alpha,beta)
quantile<-sort(x)
plot(quantile,Finv,xlab=xlab,ylab=ylab,col=4,lwd=2)
if(line==TRUE){
quant<-quantile(x)
x1<-quant[2]
x2<-quant[4]
y1<-qbs(0.25,alpha,beta)
y2<-qbs(0.75,alpha,beta)
m<-((y2-y1)/(x2-x1))
inter<-y1-(m*x1)
abline(inter,m,col=2,lwd=2)
}
}

