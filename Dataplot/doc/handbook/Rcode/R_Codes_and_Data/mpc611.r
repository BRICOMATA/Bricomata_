R commands and output:

## Read data and add column for degrees of freedom.
m <- read.table("mpc61.dat", header=FALSE)
colnames(m) <- c("run","wafer","probe","month","day","op","temp",
                 "avg","stddev")
m$dof = rep(5,length(m$avg))

## Level 1 standard deviation for probe 2362.

## Save run 1 and run 2 data in different matrices.
m1p = m[m$probe==2362&m$run==1,]
dof1 = sum(m1p$dof)
m2p = m[m$probe==2362&m$run==2,]
dof2 = sum(m2p$dof)

## Compute pooled standard deviations for each run and all data.
sp1 = sqrt(sum(m1p$dof*m1p$stddev^2)/dof1)
sp2 = sqrt(sum(m2p$dof*m2p$stddev^2)/dof2)
sp = sqrt((dof1*sp1^2 + dof2*sp2^2)/(dof1 + dof2))

## Print results.
probe = "2362"
x = data.frame(probe,round(sp1,5),dof1,round(sp2,5),dof2,
               round(sp,5),dof1+dof2)
names(x) = c("Probe", "Run 1", "DF", "Run 2", "DF", "Pooled", "DF")
x

>   Probe   Run 1  DF   Run 2  DF  Pooled  DF
> 1  2362 0.06751 150 0.07786 150 0.07287 300

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

## Print results.
dof = rep(5,length(wmn1[,1]))
probe = rep(2362,length(wmn1[,1]))
stats = data.frame(probe, unique(m1p[,2]), wmn1$x, round(wsd1$x,5), dof,
         wmn2$x, round(wsd2$x,5),dof)
colnames(stats) = c("Probe", "Wafer", "Mean1", "Std1", "DOF1",
                     "Mean2", "Std2", "DOF2")
stats

>   Probe Wafer     Mean1    Std1 DOF1     Mean2    Std2 DOF2
> 1  2362   138  95.09282 0.03594    5  95.12427 0.04532    5
> 2  2362   139  99.30595 0.04722    5  99.30978 0.02147    5
> 3  2362   140  96.03573 0.02728    5  96.07653 0.02756    5
> 4  2362   141 101.06022 0.02319    5 101.07900 0.05369    5
> 5  2362   142  94.21482 0.02744    5  94.24377 0.03698    5

## Compute pooled standard deviation across wafers.

sdf1 = sum(stats$DOF1)
sp1 = sqrt(sum(stats$DOF1*stats$Std1^2)/sdf1)

sdf2 = sum(stats$DOF2)
sp2 = sqrt(sum(stats$DOF2*stats$Std2^2)/sdf2)

## Print results.
z = data.frame(round(sp1,5), sdf1, round(sp2,5), sdf2)
names(z) = c("Run 1", "df", "Run 2", "df")
z

>     Run 1 df   Run 2 df
> 1 0.03334 25 0.03879 25

## Compute pooled standard deviation across runs.
s2 = sqrt((sdf1*sp1^2 + sdf2*sp2^2)/(sdf1 + sdf2))

## Print results.
zz = c(paste("Pooled standard deviation over two runs =",round(s2,5)),
       paste("Degrees of freedom =", (sdf1+sdf2)))
print(zz,quote=FALSE)

> [1] Pooled standard deviation over two runs = 0.03617
> [2] Degrees of freedom = 50


## Level 3 standard deviatons for probe 2362.

newdf = rbind(wmn1,wmn2)
s3 = aggregate(newdf$x,list(newdf$Group.1),sd)
diff = wmn1$x - wmn2$x

sp3 = cbind(probe, unique(m1p[,2]), wmn1$x, wmn2$x, round(diff,5), 
           round(s3$x,5), rep(1,length(diff)))
colnames(sp3) = c("Probe", "Wafer", "Mean1", "Mean2", "Diff", "STDDEV", "DOF")
sp3

>      Probe Wafer     Mean1     Mean2     Diff  STDDEV DOF
> [1,]  2362   138  95.09282  95.12427 -0.03145 0.02224   1
> [2,]  2362   139  99.30595  99.30978 -0.00383 0.00271   1
> [3,]  2362   140  96.03573  96.07653 -0.04080 0.02885   1
> [4,]  2362   141 101.06022 101.07900 -0.01878 0.01328   1
> [5,]  2362   142  94.21482  94.24377 -0.02895 0.02047   1

zz = rbind(paste("Pooled standard deviation =", round(sqrt(mean(s3$x^2)),4)),
       paste("df =", sum(sp3[,7])))
print(zz,quote=FALSE)

>      [,1]                              
> [1,] Pooled standard deviation = 0.0196
> [2,] df = 5   


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

## Print results.
ddf = data.frame(mn1$Group.3,mn1$Group.2,round(mn1$diff,4),
                 round(mn2$diff,4))
names(ddf) = c("Wafer", "Probe","Run 1","Run 2")
ddf

>    Wafer Probe   Run 1   Run 2
> 1    138     1  0.0247 -0.0119
> 2    138   281  0.0108  0.0323
> 3    138   283  0.0192 -0.0258
> 4    138  2062 -0.0175  0.0561
> 5    138  2362 -0.0372 -0.0508
> 6    139     1 -0.0035 -0.0006
> 7    139   281  0.0395  0.0051
> 8    139   283  0.0057  0.0239
> 9    139  2062 -0.0323  0.0373
> 10   139  2362 -0.0094 -0.0657
> 11   140     1  0.0400  0.0109
> 12   140   281  0.0187  0.0106
> 13   140   283 -0.0201  0.0002
> 14   140  2062 -0.0126  0.0181
> 15   140  2362 -0.0261 -0.0398
> 16   141     1  0.0393  0.0325
> 17   141   281 -0.0107 -0.0037
> 18   141   283  0.0246 -0.0190
> 19   141  2062 -0.0280  0.0436
> 20   141  2362 -0.0252 -0.0534
> 21   142     1  0.0062  0.0094
> 22   142   281  0.0376  0.0174
> 23   142   283 -0.0044  0.0193
> 24   142  2062 -0.0011  0.0008
> 25   142  2362 -0.0383 -0.0469


## Save important variables.
run = m[,1]
wafer = m[,2]
probe = m[,3]
month = m[,4]
day = m[,5]
op = m[,6]
temp = m[,7]
avg = m[,8]
stddev = m[,9]

## Generate a new codes for day and probe.
daynum = rep(1:6,50)
probenum = rep(rep(1:5,each=6),10)

## Save all data for plotting in a data frame.
df = data.frame(run,probe,probenum,stddev,wafer,day,daynum)

## Save run #1 data in a new data frame.
df1 = subset(df,run==1)

## Generate new wafer variable for plotting and add to df1 data frame.
df1$waferd = df1$wafer + (df1$daynum-3.5)/10

## Attach lattice library and generate plot for run #1 and probe #2362.
library(lattice)
xyplot(df1$stddev[df$probe==2362]~df1$waferd[df$probe==2362], 
       data=df1, groups=df1$daynum[df$probe==2362],
       main="Gauge Study Repeatability Standard Deviations by Wafer and Day", 
       sub="Code for Days: A, B, C, D, E, F",
       ylab="Standard Deviation, ohm.cm", xlab="Wafer",
       pch=c("A","B","C","D","E","F"), cex=1.2)


## Save run #1 data in a new data frame.
df2 = subset(df,run==2)

## Generate new wafer variable for plotting and add to df2 data frame.
df2$waferd = df2$wafer + (df2$daynum-3.5)/10

## Generate plot for run #2 and probe #2362.
xyplot(df2$stddev[df$probe==2362]~df2$waferd[df$probe==2362], 
       data=df2, groups=df2$daynum[df$probe==2362],
       main="Gauge Study Repeatability Standard Deviations by Wafer and Day", 
       sub="Code for Days: A, B, C, D, E, F",
       ylab="Standard Deviation, ohm.cm", xlab="Wafer",
       pch=c("A","B","C","D","E","F"), cex=1.2)


## Generate new wafer variable for plotting and add to df1 data frame.
df1$waferp = df1$wafer + (df1$probenum-3)/10

## Generate plot
xyplot(df1$stddev~df1$waferp, data=df1, groups=df1$probe,
       main="Gauge Study Repeatability Standard Deviations by Wafer and Day", 
       sub="Code for probe: 1=#1, 2=#281, 3=#283, 4=#2062, 5=#2362",
       ylab="Standard Deviation, ohm.cm", xlab="Wafer",
       pch=c("1","2","3","4","5"), cex=1.2)


## Generate new wafer variable for plotting and add to df2 data frame.
df2$waferp = df2$wafer + (df2$probenum-3)/10

## Generate plot
xyplot(df2$stddev~df2$waferp, data=df2, groups=df2$probe,
       main="Gauge Study Repeatability Standard Deviations by Wafer and Day", 
       sub="Code for probe: 1=#1, 2=#281, 3=#283, 4=#2062, 5=#2362",
       ylab="Standard Deviation, ohm.cm", xlab="Wafer",
       pch=c("1","2","3","4","5"), cex=1.2)

## Generate plot for wafer 138.

mwafer138probe2362run1 <- subset(m, wafer==138 & probe==2362 & run==1)
mwafer138probe2362run2 <- subset(m, wafer==138 & probe==2362 & run==2)

plot(mwafer138probe2362run1$month + mwafer138probe2362run1$day/30,
     mwafer138probe2362run1$avg, type="b", pch=4, xlim=c(3,5), 
     ylim=c(95,95.2), xlab= "Time in months", ylab="average in ohm.cm", 
     xaxs="i",yaxs="i")
points(mwafer138probe2362run2$month + mwafer138probe2362run2$day/30,
       mwafer138probe2362run2$avg, type="b", pch=4)
text(3.5, 95.02, "run 1", pos=4, col="red")
text(4.5, 95.02, "run 2", pos=4, col="red")
title("Averages of resistivity measurements for Wafer 138 and Probe 2362")


## Generate plot for wafer 139.

mwafer139probe2362run1 <- subset(m, wafer==139 & probe==2362 & run==1)
mwafer139probe2362run2 <- subset(m, wafer==139 & probe==2362 & run==2)

plot(mwafer139probe2362run1$month + mwafer139probe2362run1$day/30,
     mwafer139probe2362run1$avg, type="b", pch=4, xlim=c(3,5), 
     ylim=c(99.2,99.4),	xlab= "Time in months", ylab="average in ohm.cm", 
     xaxs="i",yaxs="i")
points(mwafer139probe2362run2$month + mwafer139probe2362run2$day/30,
       mwafer139probe2362run2$avg, type="b", pch=4)
text(3.5, 99.22, "run 1", pos=4, col="red")
text(4.5, 99.22, "run 2", pos=4, col="red")
title("Averages of resistivity measurements for Wafer 139 and Probe 2362")


## Generate plot for wafer 140.

mwafer140probe2362run1 <- subset(m, wafer==140 & probe==2362 & run==1)
mwafer140probe2362run2 <- subset(m, wafer==140 & probe==2362 & run==2)

plot(mwafer140probe2362run1$month + mwafer140probe2362run1$day/30,
     mwafer140probe2362run1$avg, type="b", pch=4, xlim=c(3,5), 
     ylim=c(95.9,96.2), xlab= "Time in months", ylab="average in ohm.cm", 
     xaxs="i",yaxs="i")
points(mwafer140probe2362run2$month + mwafer140probe2362run2$day/30,
       mwafer140probe2362run2$avg, type="b", pch=4)
text(3.5, 95.92, "run 1", pos=4, col="red")
text(4.5, 95.92, "run 2", pos=4, col="red")
title("Averages of resistivity measurements for Wafer 140 and Probe 2362")


## Generate plot for wafer 141.

mwafer141probe2362run1 <- subset(m, wafer==141 & probe==2362 & run==1)
mwafer141probe2362run2 <- subset(m, wafer==141 & probe==2362 & run==2)

plot(mwafer141probe2362run1$month + mwafer141probe2362run1$day/30,
     mwafer141probe2362run1$avg, type="b", pch=4, xlim=c(3,5), 
     ylim=c(100.9,101.2), xlab= "Time in months", ylab="average in ohm.cm", 
     xaxs="i",yaxs="i")
points(mwafer141probe2362run2$month + mwafer141probe2362run2$day/30,
       mwafer141probe2362run2$avg, type="b", pch=4)
text(3.5, 100.92, "run 1", pos=4, col="red")
text(4.5, 100.92, "run 2", pos=4, col="red")
title("Averages of resistivity measurements for Wafer 141 and Probe 2362")


## Generate plot for wafer 142.

mwafer142probe2362run1 <- subset(m, wafer==142 & probe==2362 & run==1)
mwafer142probe2362run2 <- subset(m, wafer==142 & probe==2362 & run==2)

plot(mwafer142probe2362run1$month + mwafer142probe2362run1$day/30,
     mwafer142probe2362run1$avg, type="b", pch=4, xlim=c(3,5), 
     ylim=c(94.1,94.35), xlab= "Time in months", 
     ylab="average in ohm.cm", xaxs="i",yaxs="i")
points(mwafer142probe2362run2$month + mwafer142probe2362run2$day/30,
       mwafer142probe2362run2$avg, type="b", pch=4)
text(3.5, 94.12, "run 1", pos=4, col="red")
text(4.5, 94.12, "run 2", pos=4, col="red")
title("Averages of resistivity measurements for Wafer 142 and Probe 2362")


## Run 1 - Graph of differences from wafer averages for 
## each of 5 probes

mpr1 <- subset(m, run==1)
mean1 <- array(0, dim=c(length(unique(mpr1$probe)), 
               length(unique(mpr1$wafer))))
plotwafer1 <- array(0, dim=c(length(unique(mpr1$probe)), 
                    length(unique(mpr1$wafer))))

for( i in 1:length(unique(mpr1$probe)) )
{
    for( j in 1:length(unique(mpr1$wafer)) )
    {
    plotwafer1[i,j] <- unique(mpr1$wafer)[j]
    mean1[i,j] <- mean(mpr1$avg[which(mpr1$probe == unique(mpr1$probe)[i] 
                       & mpr1$wafer == unique(mpr1$wafer)[j])])
    }
}
meanofmeans1 <- apply(mean1,2,mean)

plot(plotwafer1[1,], mean1[1,]-meanofmeans1, type="b", lty=3, pch=49,
     xlim=c(137,143), ylim=c(-0.04,0.04),
     xlab= "Wafer number", ylab="ohm.cm")
for(i in 2:length(unique(mpr1$probe)) )
{
    points(plotwafer1[i,], mean1[i,]-meanofmeans1, type="b", lty=3, pch=48+i)
}
segments(138,0,142,0)
title("Differences among Probes vs Wafer (run 1)")

## Run 2 - Graph of differences from wafer averages for 
## each of 5 probes 

mpr2 <- subset(m, run==2)
mean2 <- array(0, dim=c(length(unique(mpr2$probe)), 
               length(unique(mpr2$wafer))))
plotwafer2 <- array(0, dim=c(length(unique(mpr2$probe)), 
              length(unique(mpr2$wafer))))

for( i in 1:length(unique(mpr2$probe)) )
{
    for( j in 1:length(unique(mpr2$wafer)) )
    {
    plotwafer2[i,j] <- unique(mpr2$wafer)[j]
    mean2[i,j] <- mean(mpr2$avg[which(mpr2$probe == unique(mpr2$probe)[i] 
                       & mpr2$wafer == unique(mpr2$wafer)[j])])
    }
}
meanofmeans2 <- apply(mean2,2,mean)

plot(plotwafer2[1,], mean2[1,]-meanofmeans2, type="b", lty=3, pch=49,
     xlim=c(137,143), ylim=c(-0.08,0.08),
     xlab= "Wafer number", ylab="ohm.cm")
for(i in 2:length(unique(mpr2$probe)) )
{
    points(plotwafer2[i,], mean2[i,]-meanofmeans2, type="b", lty=3, pch=48+i)
}
segments(138,0,142,0)




