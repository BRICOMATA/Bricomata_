R commands and output:

## Read data and add column for degrees of freedom.
m <- read.table("mpc61.dat", header=FALSE)
colnames(m) <- c("run","wafer","probe","month","day","op","temp",
                 "avg","stddev")
m$dof = rep(5,length(m$avg))
probe = "2362"

## Level 1 standard deviation for probe 2362.

## Save run 1 and run 2 data in different matrices.
m1p = m[m$probe==2362&m$run==1,]
d1 = sum(m1p$dof)
m2p = m[m$probe==2362&m$run==2,]
d2 = sum(m2p$dof)

## Compute pooled standard deviations for each run and all data.
sp1 = sqrt(sum(m1p$dof*m1p$stddev^2)/d1)
sp2 = sqrt(sum(m2p$dof*m2p$stddev^2)/d2)
dof1 = d1 + d2
s1 = sqrt((d1*sp1^2 + d2*sp2^2)/dof1)


## Level 2 standard deviations for probe 2362.

## Compute Run 1 means and standard deviations for each wafer.
fwafer1 = as.factor(m1p$wafer)
mn1 = m1p[,8]
df1 = data.frame(fwafer1,mn1)
wmn1 = aggregate(df1$mn1,list(df1$fwafer1),mean)
wsd1 = aggregate(df1$mn1,list(df1$fwafer1),sd)

## Compute Run2 means and standard deviations for each wafer.
fwafer2 = as.factor(m2p$wafer)
mn2 = m2p[,8]
df2 = data.frame(fwafer2,mn2)
wmn2 = aggregate(df2$mn2,list(df2$fwafer2),mean)
wsd2 = aggregate(df2$mn2,list(df2$fwafer2),sd)

## Save results in a data frame.
dof = rep(5,length(wmn1[,1]))
probe = rep(2362,length(wmn1[,1]))
stats = data.frame(probe, unique(m1p[,2]), wmn1$x, round(wsd1$x,5), dof,
         wmn2$x, round(wsd2$x,5),dof)
colnames(stats) = c("Probe", "Wafer", "Mean1", "Std1", "DOF1",
                     "Mean2", "Std2", "DOF2")

## Compute pooled standard deviation across wafers.

sdf1 = sum(stats$DOF1)
sp1 = sqrt(sum(stats$DOF1*stats$Std1^2)/sdf1)

sdf2 = sum(stats$DOF2)
sp2 = sqrt(sum(stats$DOF2*stats$Std2^2)/sdf2)

## Compute pooled standard deviation across runs.
dof2 = sdf1 + sdf2
s2 = sqrt((sdf1*sp1^2 + sdf2*sp2^2)/dof2)


## Level 3 standard deviatons for probe 2362.

newdf = rbind(wmn1,wmn2)
s3 = aggregate(newdf$x,list(newdf$Group.1),sd)
diff = wmn1$x - wmn2$x

sp3 = cbind(probe, unique(m1p[,2]), wmn1$x, wmn2$x, round(diff,5), 
           round(s3$x,5), rep(1,length(diff)))
colnames(sp3) = c("Probe", "Wafer", "Mean1", "Mean2", "Diff", "STDDEV", "DOF")

dof3 = sum(sp3[,7])
s3 = sqrt(mean(s3$x^2))

## Print summary table.
lev = c("Level-1","Level-2","Level-3")
symb = c("s1","s2","s3")
est = c(s1,s2,s3)
deg = c(dof1,dof2,dof3)
zzz = data.frame(lev,symb,round(est,4),deg)
colnames(zzz) = c("Level","Symbol","Estimate","DF")
zzz

>     Level Symbol Estimate  DF
> 1 Level-1     s1   0.0729 300
> 2 Level-2     s2   0.0362  50
> 3 Level-3     s3   0.0196   5


## Calculate individual components for days and runs

sdays = sqrt(s2^2 -s1^2/6)
sdays

> [1] 0.02057092

sruns = sqrt(s3^2 - s2^2/6)
sruns

> [1] 0.01295841


## Correction for bias or probe #2362 and uncertainty

## Save variables as factors and create data frame.
fwafer = as.factor(m$wafer)
fprobe = as.factor(m$probe)
frun = as.factor(m$run)
df = data.frame(fwafer,frun,fprobe,m$avg)

## Compute cell means.
mn = aggregate(df$m.avg,list(df$frun,df$fprobe,df$fwafer),mean)
wmn = aggregate(df$m.avg,list(df$frun,df$fwafer),mean)

## Compute differences from wafer means for each run.
d = array(0, dim=c(length(mn[,1]))) 
wm = array(0, dim=c(length(mn[,1]))) 
for( i in 1:length(mn[,1]))
{
id = mn$Group.3[i]
rid = mn$Group.1[i]
wm[i] = wmn[wmn$Group.1==rid & wmn$Group.2==id,3]
d[i] = mn[i,4] - wm[i]
}
mn$diff = d

## Separate data frame into run 1 and run 2.
mn1 = mn[mn$Group.1==1,]
mn2 = mn[mn$Group.1==2,]

## Print results for probe #2362.
ddf = data.frame(mn1$Group.3,mn1$Group.2,round(mn1$diff,4),
                 round(mn2$diff,4))
names(ddf) = c("Wafer", "Probe","Run 1","Run 2")
dfp = ddf[ddf$Probe==2362,]
dfp

>    Wafer Probe   Run 1   Run 2
> 5    138  2362 -0.0372 -0.0508
> 10   139  2362 -0.0094 -0.0657
> 15   140  2362 -0.0261 -0.0398
> 20   141  2362 -0.0252 -0.0534
> 25   142  2362 -0.0383 -0.0469

rbind(paste("Run 1 Average =", round(mean(dfp[,3]),4)),
paste("Run 2 Average =", round(mean(dfp[,4]),4)),
paste("Overall Average =", round(mean(c(dfp[,3],dfp[,4])),4)),
paste("Overall Standard Deviation =", round(sd(c(dfp[,3],dfp[,4])),4)) )

>      [,1]                                 
> [1,] "Run 1 Average = -0.0272"            
> [2,] "Run 2 Average = -0.0513"            
> [3,] "Overall Average = -0.0393"          
> [4,] "Overall Standard Deviation = 0.0162"

## Save sprobe for later use.
sprobe = sd(c(dfp[,3],dfp[,4]))
dfprobe = length(c(dfp[,3],dfp[,4]))-1


## Read data.
m <- read.table("check_std.dat", skip=2)
colnames(m) <- c("wafer","probe","cona1","cona1s","conb1","conb1s",
                 "cona2","cona2s","conb2","conb2s")

## Compute differences between configurations.
diff1 = m$cona1 - m$conb1
diff2 = m$cona2 - m$conb2

## Test for significant differences between configurations.
t1 = t.test(diff1)
t2 = t.test(diff2)

## Print results.
Status = c("Pre","Post")
Average = round(c(mean(diff1),mean(diff2)),4)
Stddev = round(c(sd(diff1),sd(diff2)),4)
DF = c(length(diff1)-1,length(diff2-1))
t = round(c(t1$statistic,t2$statistic),2)
data.frame(Status,Average,Stddev,DF,t)

>   Status Average Stddev DF     t
> 1    Pre -0.0086 0.0242 29 -1.94
> 2   Post -0.0119 0.0354 30 -1.84


## Standard uncertainty includes components for 
## repeatability, days, runs and probe

u = sqrt(5*s2^2/6 + s3^2 + sprobe^2/10)
u

> [1] 0.03875842


## Approximate degrees of freedom and expanded uncertainty

a = c(0,sqrt(5/6),1,sqrt(1/10))
s = c(s1,s2,s3,sprobe)
df = c(dof1,dof2,dof3,dfprobe)
v = round(u^4 / sum((a^4)*(s^4)/df))
v

> [1] 42

round(qt(0.975,v)*u,4)

> [1] 0.0782


## Read data.
m <- read.table("check_std.dat",header=TRUE)
colnames(m) <- c("wafer", "probe", "avgArun1", "sdArun1", "avgBrun1", 
                 "sdBrun1","avgArun2", "sdArun2", "avgBrun2", "sdBrun2")

## Define the probe ID vector as:  1 = 50, ..., 5 = 54.
SortWafer <- sort(unique(m$wafer))

## Generate plot for Run 1.
plot(c(1:nrow(m)), m$avgArun1 - m$avgBrun1, 
     pch=48 + match(m$wafer,SortWafer),
     xlab="Run order", ylab="ohm.cm",
     xlim=c(0,31), ylim=c(-0.1,0.1), col="dark green")
segments(1,0, nrow(m),0, col="dark green")
title("Difference between wiring configurations A and B")
text(2, 0.1, 
"Wafer legend \n 1 = 138 \n 2 = 139 \n 3 = 140 \n 4 = 141 \n 5 = 142 ",
pos=1, cex=0.8)
text(28, 0.1, "Run 1", pos=1, col="dark green")

## Generate plot for Run 2.
plot(c(1:nrow(m)), m$avgArun2 - m$avgBrun2, 
     pch=48 + match(m$wafer,SortWafer),
     xlab="Run order", ylab="ohm.cm",
     xlim=c(0,31), ylim=c(-0.1,0.1), col="dark green")
segments(1,0, nrow(m),0, col="dark green")
title("Difference between wiring configurations A and B")
text(2, 0.1, 
"Wafer legend \n 1 = 138 \n 2 = 139 \n 3 = 140 \n 4 = 141 \n 5 = 142 ",
pos=1, cex=0.8)
text(28, 0.1, "Run 2", pos=1, col="dark green")
