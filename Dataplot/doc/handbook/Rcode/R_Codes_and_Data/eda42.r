R commands for ceramic strength case study (1.4.2.10):

############################
## Analyses for 1.4.2.10.2 #
############################

## Read data.
fname <- "jahanmi2.dat"
m <- matrix(scan(fname,skip=50),ncol=16,byrow=T)
y = m[,5]
x1 = m[,6]
x2 = m[,7]
x3 = m[,8]
x4 = m[,9]
lab = m[,2]
batch = m[,14]

## Compute summary statistics.
ybar = round(mean(y),5)
std = round(sd(y),5)
n = round(length(y),0)
stderr = round(std/sqrt(n),5)
v = round(var(y),5)

## Compute the five number summary.
## min, lower hinge, Median, upper hinge, max
z = fivenum(y)
lhinge = round(z[2],5)
uhinge = round(z[4],5)
rany = round((max(y)-min(y)),5)

## Compute the inter-quartile range.
iqry = round(IQR(y),5)

## Compute the lag 1 autocorrelation.
z = acf(y)
ac = round(z$acf[2],5)

## Format and print results.
Statistics = c(n,ybar,std,stderr,v,rany,lhinge,uhinge,iqry,ac)
names(Statistics)= c("Number of Observations ", "Mean", "Std. Dev.", 
                "Std. Dev. of Mean", "Variance", "Range",
                "Lower Hinge", "Upper Hinge", "Inter-Quartile Range",
                "Autocorrelation")
data.frame(Statistics)
summary(y)

## Generate a 4-plot of the data.
library(Hmisc)
par(mfrow = c(2, 2),
      oma = c(0, 0, 2, 0),
      mar = c(5.1, 4.1, 2.1, 2.1)) 
plot(y,ylab="Y",xlab="Run Sequence")
plot(y,Lag(y),xlab="Y[i-1]",ylab="Y[i]")
hist(y,main="",xlab="Y")
qqnorm(y,main="")
mtext("Strength of Ceramic Material: 4-Plot", line = 0.5, outer = TRUE)
par(mfrow=c(1,1))

############################
## Analyses for 1.4.2.10.3 #
############################

## Generate bihistogram.
library(Hmisc)
histbackback(split(y,batch),ylab="Strength of Ceramic",
             brks=seq(300,900,by=25))

## Generate a quantile-quantile plot for the two batches.
df = data.frame(y,batch)
y1 = df[batch==1,1]
y2 = df[batch==2,1]
qqplot(y2,y1)
abline(0,1)
title(sub="Quantile-Quantile Plot Y1 Y2")

## Generate a box plot for each batch.
boxplot(y~batch,ylab="Ceramic Strength",xlab="Batch")
title("Box Plot by Batch")

## Save variables as factors.
fx1 = factor(x1)
fx2 = factor(x2)
fx3 = factor(x3)
flab = factor(lab)
fbatch = factor(batch)
df = data.frame(y,fbatch,flab,fx1,fx2,fx3)

## Generate four plots on one page.
par(mfrow=c(2,2))

## Plot #1
## Compute the batch means for each laboratory.
avg = aggregate(x=df$y, by=list(df$flab,df$fbatch), FUN="mean")

## Generate the block plot.
boxplot(avg$x ~ avg$Group.1, medlty="blank",
        ylab="Ceramic Strength",xlab="Laboratory",
        main="Batch Means for Each Laboratory")
## Add labels for the batch means.
text(avg$Group.1[avg$Group.2==1], avg$x[avg$Group.2==1],
     labels=avg$Group.2[avg$Group.2==1], pos=1)
text(avg$Group.1[avg$Group.2==2], avg$x[avg$Group.2==2],
     labels=avg$Group.2[avg$Group.2==2], pos=3)

## Plot #2
## Generate the block plot for the first factor.
## Create new variable that indicates batch*x1.
## The new variable is necessary to preserve the order
## of the blocks within laboratory.
newx1 = x1/5
lx1 = factor(lab + newx1)
df = data.frame(y,fbatch,lx1)

## Compute the batch means for each laboratory and level of x1.
avg = aggregate(x=df$y, by=list(df$fbatch,df$lx1), FUN="mean")
## Specify locations of the bars on the x axis.
xpos = c(1,5,8,10,13:14,16:17,19:20,22:23)
boxplot(avg$x ~ avg$Group.2, medlty="blank", xlim=c(1,24),
        ylab="Ceramic Strength",xlab="Laboratory and x1",
        at=xpos,xaxt="n",main="Batch Means:  Lab and x1")
axis(side=1,at=c(1.5,4.5,7.5,10.5,13.5,16.5,19.5,22.5),
     labels=c("1","2","3","4","5","6","7","8"))
## Add labels for the batch means.
text(xpos,avg$x[avg$Group.1==1],
     labels=avg$Group.1[avg$Group.1==1], pos=1)
text(xpos,avg$x[avg$Group.1==2],
     labels=avg$Group.1[avg$Group.1==2], pos=3)

## Plot #3
## Generate the block plot for the second factor.
## Create new variable that indicates batch*x2.
newx2 = x2/5
lx2 = factor(lab + newx2)
df = data.frame(y,fbatch,lx2)
## Compute the batch means for each laboratory and level of x2.
avg = aggregate(x=df$y, by=list(df$fbatch,df$lx2), FUN="mean")
## Specify locations of the bars on the x axis.
xpos = c(1:2,4:5,7:8,10:11,13,17,20,22)
boxplot(avg$x ~ avg$Group.2, medlty="blank", xlim=c(1,24),
        ylab="Ceramic Strength",xlab="Laboratory and x2",
        at=xpos ,xaxt="n",main="Batch Means:  Lab and x2")
axis(side=1,at=c(1.5,4.5,7.5,10.5,13.5,16.5,19.5,22.5),
     labels=c("1","2","3","4","5","6","7","8"))
## Add labels for the batch means.
text(xpos, avg$x[avg$Group.1==1],
     labels=avg$Group.1[avg$Group.1==1], pos=1)
text(xpos, avg$x[avg$Group.1==2],
     labels=avg$Group.1[avg$Group.1==2], pos=3)

## Plot #4
## Generate the block plot for the third factor.
## Create new variable that indicates batch*x3.
newx3 = x3/5
lx3 = factor(lab + newx3)
df = data.frame(y,fbatch,lx3)
## Compute the batch means for each laboratory and level of x3.
avg = aggregate(x=df$y, by=list(df$fbatch,df$lx3), FUN="mean")
## Specify locations of the bars on the x axis.
xpos = c(1:2,4:5,7:8,10:11,13:14,16:17,19:20,22:23)
boxplot(avg$x ~ avg$Group.2, medlty="blank", xlim=c(1,24),
        ylab="Ceramic Strength",xlab="Laboratory and x3",
        at=xpos ,xaxt="n",main="Batch Means:  Lab and x3")
axis(side=1,at=c(1.5,4.5,7.5,10.5,13.5,16.5,19.5,22.5),
     labels=c("1","2","3","4","5","6","7","8"))
## Add labels for the batch means.
text(xpos, avg$x[avg$Group.1==1],
     labels=avg$Group.1[avg$Group.1==1], pos=1)
text(xpos, avg$x[avg$Group.1==2],
     labels=avg$Group.1[avg$Group.1==2], pos=3)
par(mfrow=c(1,1))

## Perform an F-test to compare two variances.
var.test(y~batch)

## Perform a two-sample T-test for the case where group variances
## are equal.
t.test(y~batch,var.equal=TRUE,alternative="greater")

############################
## Analyses for 1.4.2.10.4 #
############################

## Generate box plot for each laboratory.
boxplot(y~lab,ylab="Ceramic Strength",xlab="Laboratory")

## Create a dataframe with batch 1 data and generate the box plot.
df = data.frame(y,lab,batch)
df1 = df[df$batch==1,]
boxplot(y~lab,data=df1,ylab="Ceramic Strength",xlab="Laboratory")
title("Batch Number 1")

## Create a dataframe with batch 2 data and generate the box plot.
df2 = df[df$batch==2,]
boxplot(y~lab,data=df2,ylab="Ceramic Strength",xlab="Laboratory")
title("Batch Number 2")

############################
## Analyses for 1.4.2.10.5 #
############################

## Generate DEX scatter plot for batch 1.
batch = factor(m[,14])

## Restructure data so that x1, x2, and x3 are in a single column.
## Also, save re-coded version of the factor levels for DEX mean plot.
tempx  = x1
tempxc = x1 + 1
dm1 = cbind(y,lab,batch,tempx,tempxc)
tempx  = x2
tempxc = x2 + 4
dm2 = cbind(y,lab,batch,tempx,tempxc)
tempx  = x3
tempxc = x3 + 7
dm3 = cbind(y,lab,batch,tempx,tempxc)
dm4 = rbind(dm1,dm2,dm3)

## Generate factor ID variable.
n = length(y)
varind = c(rep("Table Speed",n),rep("Feed Rate",n),rep("Wheel Grit Size",n))
varind = as.factor(varind)

## Create a dataframe with "stacked" factors and data.
df = data.frame(dm4,varind)

## Create a dataframe for batch 1 data.
df1 = df[df$batch==1,]

## Attach lattice library and generate the DEX scatter plot.
library(lattice)
xyplot(y~tempx|varind,data=df1,layout=c(3,1),xlim=c(-2,2),
       ylab="Ceramic Strength",xlab="Factor Levels",
       main="Batch 1")

## Comute grand mean for batch 1.
ybar = mean(m[ m[,14]==1,5])

## Generate DEX mean plot.
interaction.plot(df1$tempxc,df1$varind,df1$y,fun=mean,
                 ylab="Ceramic Strength",xlab="",main="Batch 1 Means",
                 trace.label="Factor",type="b",pch=19,
                 legend=FALSE,xaxt="n")
xpos = c(1.5,3.5,5.5)
xlabel = c("Table Speed","Feed Rate","Wheel Grit Size")
axis(side=1,at=xpos,labels=xlabel)
abline(h=ybar)

## Comute overall standard deviation for batch 1.
sdy = sd(m[ m[,14]==1,5])

## Generate DEX standard deviation plot.
interaction.plot(df1$tempxc,df1$varind,df1$y,fun=sd,
                 ylab="Ceramic Strength",xlab="",
                 main="Batch 1 Standard Deviations",
                 trace.label="Factor",type="b",pch=19,
                 legend=FALSE,xaxt="n")
xpos = c(1.5,3.5,5.5)
xlabel = c("Table Speed","Feed Rate","Wheel Grit Size")
axis(side=1,at=xpos,labels=xlabel)
abline(h=sdy)

## Create a dataframe with batch 2 data.
df2 = df[df$batch==2,]

## Attach lattice library and generate the DEX scatter plot.
library(lattice)
xyplot(y~tempx|varind,data=df2,layout=c(3,1),xlim=c(-2,2),
       ylab="Ceramic Strength",xlab="Factor Levels",
       main="Batch 2")

## Comute grand mean for batch 2.
ybar = mean(m[ m[,14]==2,5])

## Generate DEX mean plot.
interaction.plot(df2$tempxc,df2$varind,df2$y,fun=mean,
                 ylab="Ceramic Strength",xlab="",main="Batch 2 Means",
                 trace.label="Factor",type="b",pch=19,
                 legend=FALSE,xaxt="n")
xpos = c(1.5,3.5,5.5)
xlabel = c("Table Speed","Feed Rate","Wheel Grit Size")
axis(side=1,at=xpos,labels=xlabel)
abline(h=ybar)

## Comute grand mean for batch 2.
sdy = sd(m[ m[,14]==2,5])

## Generate DEX standard deviation plot.
interaction.plot(df2$tempxc,df2$varind,df2$y,fun=sd,
                 ylab="Ceramic Strength",xlab="",
                 main="Batch 2 Standard Deviations",
                 trace.label="Factor",type="b",pch=19,
                 legend=FALSE,xaxt="n")
xpos = c(1.5,3.5,5.5)
xlabel = c("Table Speed","Feed Rate","Wheel Grit Size")
axis(side=1,at=xpos,labels=xlabel)
abline(h=sdy)

## DEX Interaction Plot for Batch 1 

## Create dataframe.
x12 = x1*x2
x13 = x1*x3
x23 = x2*x3
fx1 = factor(x1)
fx2 = factor(x2)
fx3 = factor(x3)
fx12 = factor(x12)
fx13 = factor(x13)
fx23 = factor(x23)
dfip = data.frame(y,batch,fx1,fx2,fx3,fx12,fx13,fx23)

## Create a dataframe for batch 1 data.
dfip1 = dfip[dfip$batch==1,]

## Compute overall batch mean.
ybar1 = mean(dfip1$y)

## Compute effect estimates and factor means.
q = aggregate(x=dfip1$y,by=list(dfip1$fx1),FUN="mean")
x1lo = q[1,2]
x1hi = q[2,2]
e1 = x1lo-x1hi

q = aggregate(x=dfip1$y,by=list(dfip1$fx2),FUN="mean")
x2lo = q[1,2]
x2hi = q[2,2]
e2 = x2lo - x2hi

q = aggregate(x=dfip1$y,by=list(dfip1$fx3),FUN="mean")
x3lo = q[1,2]
x3hi = q[2,2]
e3 = x3lo - x3hi

q = aggregate(x=dfip1$y,by=list(dfip1$fx12),FUN="mean")
x12lo = q[1,2]
x12hi = q[2,2]
e12 = x12lo - x12hi

q = aggregate(x=dfip1$y,by=list(dfip1$fx13),FUN="mean")
x13lo = q[1,2]
x13hi = q[2,2]
e13 = x13lo - x13hi

q = aggregate(x=dfip1$y,by=list(dfip1$fx23),FUN="mean")
x23lo = q[1,2]
x23hi = q[2,2]
e23 = x23lo - x23hi

## Create factor labels from effect values.
e = round(c(e3,e2,e23,e1,e12,e13),2)
textlabs = c("X3 Effect =","X2 Effect =","X2*X3 Effect =",
             "X1 Effect =","X1*X2 Effect =","X1*X3 Effect =")
labs = paste(textlabs,e)
group = factor(c(1:6),labels=labs)

## Create data frame with factor level means.
x = c(x3lo,x2lo,x23lo,x1lo,x12lo,x13lo)
xlev = rep(-1,6)
xlo = cbind(x,xlev,group)

x = c(x3hi,x2hi,x23hi,x1hi,x12hi,x13hi)
xlev = rep(1,6)
xhi = cbind(x,xlev,group)

m = rbind(xlo,xhi)
m = as.data.frame(m)

## Customize Lattice plot layout and color.
sp = c(T,T,F,T,F,F,F,F,F)
strip.bg_custom = trellis.par.get("strip.background")
strip.bg_custom$col =c("#cce6ff","#ffe5cc","#ccffcc","#ccffff","#ffccff",
                       "#ffcccc","#ffffcc")
strip.sh_custom = strip.bg_custom
trellis.par.set("strip.background", strip.bg_custom)
trellis.par.set("strip.shingle", strip.sh_custom)

## Generate plot.
xyplot(x~xlev | group, data=m, type="b", xlim=c(-2,2),
       layout=c(3,3), skip=sp, col=c(4), 
       strip = function(..., style,factor.levels,strip.levels,strip.names)
               strip.default(..., style = 1,factor.levels=labs,
                             strip.levels=c(F,T),strip.names=c(T,F)),
       xlab="Factor Level", ylab="Strength", main="Batch 1",
panel = function(x, y, ...){
panel.xyplot(x, y, ...)
panel.abline(h = ybar1, lty = 2, col = 2)
}
)

## DEX Interaction Plot for Batch 2

## Create a dataframe for batch 2 data.
dfip2 = dfip[dfip$batch==2,]

## Compute overall batch mean.
ybar2 = mean(dfip2$y)

## Compute effect estimates and factor means.
q = aggregate(x=dfip2$y,by=list(dfip2$fx1),FUN="mean")
x1lo = q[1,2]
x1hi = q[2,2]
e1 = x1lo-x1hi

q = aggregate(x=dfip2$y,by=list(dfip2$fx2),FUN="mean")
x2lo = q[1,2]
x2hi = q[2,2]
e2 = x2lo - x2hi

q = aggregate(x=dfip2$y,by=list(dfip2$fx3),FUN="mean")
x3lo = q[1,2]
x3hi = q[2,2]
e3 = x3lo - x3hi

q = aggregate(x=dfip2$y,by=list(dfip2$fx12),FUN="mean")
x12lo = q[1,2]
x12hi = q[2,2]
e12 = x12lo - x12hi

q = aggregate(x=dfip2$y,by=list(dfip2$fx13),FUN="mean")
x13lo = q[1,2]
x13hi = q[2,2]
e13 = x13lo - x13hi

q = aggregate(x=dfip2$y,by=list(dfip2$fx23),FUN="mean")
x23lo = q[1,2]
x23hi = q[2,2]
e23 = x23lo - x23hi

## Create factor labels from effect values.
e = round(c(e3,e2,e23,e1,e12,e13),2)
textlabs = c("X3 Effect =","X2 Effect =","X2*X3 Effect =",
             "X1 Effect =","X1*X2 Effect =","X1*X3 Effect =")
labs = paste(textlabs,e)
group = factor(c(1:6),labels=labs)

## Create data frame with factor level means.
x = c(x3lo,x2lo,x23lo,x1lo,x12lo,x13lo)
xlev = rep(-1,6)
xlo = cbind(x,xlev,group)

x = c(x3hi,x2hi,x23hi,x1hi,x12hi,x13hi)
xlev = rep(1,6)
xhi = cbind(x,xlev,group)

m = rbind(xlo,xhi)
m = as.data.frame(m)

## Customize Lattice plot layout and color.
sp = c(T,T,F,T,F,F,F,F,F)
strip.bg_custom = trellis.par.get("strip.background")
strip.bg_custom$col =c("#cce6ff","#ffe5cc","#ccffcc","#ccffff","#ffccff",
                       "#ffcccc","#ffffcc")
strip.sh_custom = strip.bg_custom
trellis.par.set("strip.background", strip.bg_custom)
trellis.par.set("strip.shingle", strip.sh_custom)

## Generate plot.
xyplot(x~xlev | group, data=m, type="b", xlim=c(-2,2),
       layout=c(3,3), skip=sp, col=c(4), 
       strip = function(..., style,factor.levels,strip.levels,strip.names)
               strip.default(..., style = 1,factor.levels=labs,
                             strip.levels=c(F,T),strip.names=c(T,F)),
       xlab="Factor Level", ylab="Strength", main="Batch 2",
panel = function(x, y, ...){
panel.xyplot(x, y, ...)
panel.abline(h = ybar2, lty = 2, col = 2)
}
)



