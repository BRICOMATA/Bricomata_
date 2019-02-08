`rbs1` <-
function(n,alpha=1.0,beta=1.0)
{
if(!is.numeric(n)||!is.numeric(alpha)||!is.numeric(beta)) 
{stop("non-numeric argument to mathematical function")}
if(n<=0){stop("value of n must be greater or equal then 1")}
if(alpha<=0){stop("alpha must be positive")}
if(beta<=0){stop("beta must be positive")}
t<-seq(1,n);
z<-rnorm(n,mean=0,sd=1) 
a<-1;
b<-(-1*beta)*(2+(alpha*z*z));
c<-(beta^2);
sol1<-((-1*b)-sqrt((b^2)-(4*a*c)))/(2*a);
sol2<-((-1*b)+sqrt((b^2)-(4*a*c)))/(2*a);
for(i in 1:n)
{
u<-runif(1,0,1);
t1<-sol1[i];
t2<-sol2[i];
if(u<=0.5){t[i]=t1}else{t[i]=t2}
}
return(t)
}

