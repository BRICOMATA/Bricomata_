`gmbs` <-
function(x)
{
if(!is.numeric(x)) 
{stop("non-numeric argument to mathematical function")}
n<-length(t<-x)
i<-seq(1:n)
F<-((i-0.3)/(n+0.4))
p<-sqrt(t)*qnorm(F)
reg<-lm(t ~ 1 + p)
abstract<-summary(reg)
C<-abstract$coefficients
R<-abstract$r.squared
a<-C[1]
b<-C[2]
beta<-a
alpha<-b/sqrt(a)
x1<-p[1]
x2<-p[n]
y1<-a+(b*p[1])
y2<-a+(b*p[n])
plot(p,t,
xlab=expression(sqrt(t)*Phi^-1*(p)),ylab='t',col=4,lwd=2)
lines(c(x1,x2),c(y1,y2),col=2,lwd=2)
listbs<-list(alpha=alpha,beta=beta,r.squared=R)
return(listbs)
}

