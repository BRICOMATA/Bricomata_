`simul.bs.gme` <-
function(n,alpha,beta){
if(!is.numeric(n)||!is.numeric(alpha)||!is.numeric(beta)) 
stop ("non-numeric argument to mathematical function")
if(alpha<=0){stop("alpha must be positive")}
if(beta<=0){stop("beta must be positive")}
sam1<-rbs1(n,alpha,beta)
sam2<-rbs2(n,alpha,beta)
sam3<-rbs3(n,alpha,beta)
sample1<-sam1
sample2<-sam2
sample3<-sam3
pm1<-est2bs(sam1)
pm2<-est2bs(sam2)
pm3<-est3bs(sam3)
a1<-pm1$alpha
a2<-pm2$alpha
a3<-pm3$alpha
b1<-pm1$beta
b2<-pm2$beta
b3<-pm3$beta
ks1<-ks.test(sam1,pbs,a1,b1,alternative="two.sided")
ks2<-ks.test(sam2,pbs,a2,b2,alternative="two.sided")
ks3<-ks.test(sam3,pbs,a3,b3,alternative="two.sided")
sta1<-ks1$statistic
sta2<-ks2$statistic
sta3<-ks3$statistic
pval1<-ks1$p.value
pval2<-ks2$p.value
pval3<-ks3$p.value
ma<-matrix(nrow=3,ncol=4,
dimnames=list(c("Sample1","Sample2","Sample3"),
c("GME(alpha)","GME(beta)", "KS","p-value")))
ma[1,1]<-a1
ma[1,2]<-b1
ma[1,3]<-sta1
ma[1,4]<-pval1
ma[2,1]<-a2
ma[2,2]<-b2
ma[2,3]<-sta2
ma[2,4]<-pval2
ma[3,1]<-a3
ma[3,2]<-b3
ma[3,3]<-sta3
ma[3,4]<-pval3
setClass("simulBsClass",representation(sample1="numeric",sample2="numeric",sample3="numeric",results="matrix"))
resultOfSimul<-new("simulBsClass",sample1=sample1,sample2=sample2,sample3=sample3,results=ma)
return(resultOfSimul)
}

