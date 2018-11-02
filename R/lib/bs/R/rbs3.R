`rbs3` <-
function(n,alpha=1.0,beta=1.0){
if(!is.numeric(n)||!is.numeric(alpha)||!is.numeric(beta)) 
{stop("non-numeric argument to mathematical function")}
if(n<=0){stop("value of n must be greater or equal then 1")}
if(alpha<=0){stop("alpha must be positive")}
if(beta<=0){stop("beta must be positive")}
rig<-function(n,mu=1.0,lambda=1.0){
z<-rnorm(n,0,1)
v0<-z^2
x1<-mu+(((mu^2)*v0)/(2*lambda))-(mu/(2*lambda))*sqrt(4*mu*lambda*v0+((mu^2)*(v0^2)))
x2<-(mu^2)/x1
p0<-mu/(mu*(mu+x1))
u0<-runif(n,0,1)
y<-seq(1,n,by=1)
for(i in 1:n)
{
val1<-u0[i]
val2<-p0[i]
if(val1<=val2){y[i]<-x1[i]}else{y[i]<-x2[i]}
}
return(y)
}
x1<-rig(n,beta,(alpha^(-2))*beta)
x2<-rig(n,beta^(-1),(alpha^(-2))*(beta^(-1)))
s<-1/x2
w<-rbinom(n,1,0.5)
t<-(w*x1)+((1-w)*s)
return(t)
}

