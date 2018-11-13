R commands and output:

## Read the data and define variables.
m = read.table(mpc536.dat, header=FALSE)
wafer = m[,1]
day = m[,2]
probe = m[,3]
d1 = m[,4]
d2 = m[,5]

## Definition of the wafer ID vector for plotting.
pchMat = vector("integer", length=nrow(m))
num = 49
pchMat[] = num

for( i in 2:nrow(m) ){
	if(wafer[i] != wafer[i-1]){
		num = num + 1
		pchMat[i:nrow(m)] = num} }

## Plot the differences between wiring configurations for run 1.
par(mfrow=c(2,1),bg=rgb(1,1,0.8))
plot(c(1:nrow(m)), d1, type="p", pch=pchMat, 
	xlab= "sequence for 5 wafers and 6 days", ylab="difference in ohm.cm")
title("Difference between 2 wiring configurations, run 1") 
segments(x0=0, y0=0, x1=30, y1=0, col="dark orange")
text(1, min(d1), "* coded by wafer ID", pos=4, cex=0.8, col="red")

## Plot the differences between wiring configurations for run 2.
plot(c(1:nrow(m)), d2, type="p", pch=pchMat, 
	xlab= "sequence for 5 wafers and 6 days", ylab="difference in ohm.cm")
title("Difference between 2 wiring configurations, run 2") 
segments(x0=0, y0=0, x1=30, y1=0, col="dark orange")
text(1, min(d2), "* coded by wafer ID", pos=4, cex=0.8, col="red")

## Compute average difference for each run.
avgrun1 = mean(d1)
avgrun2 = mean(d2)

## Compute standard deviation for each run.
sdrun1 = sd(d1)
sdrun2 = sd(d2)
	
## t-test statistic for difference between configurations
t1 = sqrt(nrow(m)-1)*avgrun1/sdrun1
t2 = sqrt(nrow(m)-1)*avgrun2/sdrun2

## Print results.
avg = rbind(avgrun1,avgrun2)
std = rbind(sdrun1,sdrun2)
tstat = rbind(t1,t2)
round(data.frame(avg,std,tstat),6)

>               avg      std     tstat
> avgrun1 -0.003834 0.005145 -3.943518
> avgrun2  0.004886 0.004004  6.456969

## quantile function for the t-distribution
t = qt(p=0.975, df=nrow(m)-1)
print(paste("t critical value =", round(t,3)))

> [1] "t critical value = 2.048"