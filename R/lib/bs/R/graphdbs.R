`graphdbs` <-
function(a1,a2,a3,a4,a5,b1,b2,b3,b4,b5)
{
if(!is.numeric(a1)||!is.numeric(a2)||!is.numeric(a3)||!is.numeric(a4)||!is.numeric(a5)) 
stop ("non-numeric argument to mathematical function")
if(!is.numeric(b1)||!is.numeric(b2)||!is.numeric(b3)||!is.numeric(b4)||!is.numeric(b5)) 
stop ("non-numeric argument to mathematical function")
if(a1<=0||a2<=0||a3<=0||a4<=0||a5<=0){stop("alpha values must be positive")}
if(b1<=0||b2<=0||b3<=0||b4<=0||b5<=0){stop("beta values must be positive")}
t<-seq(0,5,by=0.001)
ft1<-dbs(t,a1,b1)
ft2<-dbs(t,a2,b2)
ft3<-dbs(t,a3,b3)
ft4<-dbs(t,a4,b4)
ft5<-dbs(t,a5,b5)
ft<-cbind(ft1,ft2,ft3,ft4,ft5)
matplot(t,ft,type="l",col=c(1,2,3,4,8),lty=c(1,1,1,1,1),lwd=c(2,2,2,2,2), ylab="f(t)", main="")
}

