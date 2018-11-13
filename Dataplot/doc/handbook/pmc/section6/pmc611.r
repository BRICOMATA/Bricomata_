R commands and output:

## Read the data and save some variables as factors.
m = read.table("monitor-6.6.1.1.dat",skip=4)
cassette = as.factor(m[,1])
wafer = as.factor(m[,2])
site = as.factor(m[,3])
raw = m[,4]
order = m[,5]


## Generate a 4-plot of the data.
library(Hmisc)
par(mfrow=c(2,2))
plot(raw,ylab="Raw Line Width",type="l")
plot(Lag(raw,1),raw,ylab="Raw Line Width",xlab="lag(Raw Line Width)")
hist(raw,main="",xlab="Raw Line Width")
qqnorm(raw,main="")
par(mfrow=c(1,1))


## Generate a run-order plot of the data.
plot(raw,ylab="Raw Line Width",xlab="Sequence",type="l")


## Generate a numerical Summary.

## Compute summary statistics.
ybar = round(mean(raw),5)
std = round(sd(raw),5)
n = round(length(raw),0)
stderr = round(std/sqrt(n),5)
v = round(var(raw),5)

# Compute the five-number summary.
# min, lower hinge, Median, upper hinge, max
z = fivenum(raw)
lhinge = round(z[2],5)
uhinge = round(z[4],5)
rany = round((max(raw)-min(raw)),5)

## Compute the inter-quartile range.
iqry = round(IQR(raw),5)

## Compute the lag 1 autocorrelation.
z = acf(raw,plot=FALSE)
ac = round(z$acf[2],5)

## Format results for printing.
Statistics = c(n,ybar,std,stderr,v,rany,lhinge,uhinge,iqry,ac)
names(Statistics)= c("Number of Observations ", "Mean", "Std. Dev.", 
                "Std. Dev. of Mean", "Variance", "Range",
                "Lower Hinge", "Upper Hinge", "Inter-Quartile Range",
                "Autocorrelation")

data.frame(Statistics)

##>                         Statistics
##> Number of Observations   450.00000
##> Mean                       2.53228
##> Std. Dev.                  0.69376
##> Std. Dev. of Mean          0.03270
##> Variance                   0.48130
##> Range                      4.42212
##> Lower Hinge                2.04814
##> Upper Hinge                2.97195
##> Inter-Quartile Range       0.91928
##> Autocorrelation            0.60726


## Generate a scatter plot of width versus cassette.
plot(m[,1], raw, xlab="Cassette", ylab="Raw Line Width")


## Generate a box plot of width versus cassette.
boxplot(raw ~ cassette, xlab="Cassette", ylab="Raw Line Width")


## Generate a scatter plot of width versus wafer.
plot(m[,2], raw, xlab="Wafer", ylab="Raw Line Width", xlim=c(0,4),
     xaxt="n")
axis(1,at=c(0:4),labels=c("","1","2","3",""))


## Generate a box plot of width versus wafer.
boxplot(raw ~ wafer, xlab="Wafer", ylab="Raw Line Width")


## Generate a scatter plot of width versus site.

## Save site as a numeric variable.
## The numbers 1-5 in nsite correspond to levels: Bot Cen Lef Rgt Top.
nsite = as.numeric(site)
plot(nsite, raw, xlab="Site", ylab="Raw Line Width", xaxt="n")
axis(1,at=c(1:5),labels=c("Bottom","Center","Left","Right","Top"))


## Generate a box plot of width versus site.
boxplot(raw ~ site, xlab="Site", ylab="Raw Line Width", xaxt="n")
axis(1,at=c(1:5),labels=c("Bottom","Center","Left","Right","Top"))


## Generate a Dex mean plot.

## Restructure data so that factors are in a single column.
## Save re-coded version of the factor levels for DEX mean plot.
tempxc = round(m[,1]/6,2) + 1
dm1 = cbind(raw,tempxc)
tempxc = m[,2] + 8
dm2 = cbind(raw,tempxc)
tempxc = nsite + 13
dm3 = cbind(raw,tempxc)
dm4 = rbind(dm1,dm2,dm3)

## Generate factor ID variable.
n = length(raw)
varind = c(rep("Cassette",n),rep("Wafer",n),rep("Site",n))
varind = as.factor(varind)

## Save restructured data in a data frame.
df = data.frame(dm4,varind)

## Generate plot.
q = aggregate(x=df$raw,by=list(df$varind,df$tempxc),FUN="mean")
plot(q$Group.2, q$x, ylab="Raw Line Width", xlab="Factors", 
     pch=19, xaxt="n", ylim=c(1,5))
xpos = c(3.5,10,16)
xlabel = c("Cassette","Wafer","Site")
axis(side=1,at=xpos,labels=xlabel)
abline(h=mean(raw))


## Generate a Dex sd plot.
q = aggregate(x=df$raw,by=list(df$varind,df$tempxc),FUN="sd")
plot(q$Group.2, q$x, ylab="Raw Line Width", xlab="Factors", 
     pch=19, xaxt="n", ylim=c(.4,.8))
xpos = c(3.5,10,16)
xlabel = c("Cassette","Wafer","Site")
axis(side=1,at=xpos,labels=xlabel)
abline(h=sd(raw))


## Generate moving average control chart.
raw.mr = abs(raw - Lag(raw))
raw.ma = (raw + Lag(raw))/2

center = mean(raw.ma[2:length(raw)])
mn.mr  = mean(raw.mr[2:length(raw)])
d2 = 1.128
lcl = center - 3*mn.mr/d2
ucl = center + 3*mn.mr/d2

## Generate plot.
plot(raw.ma, ylim=c(1,5), type="l", ylab="Moving average of line width")
abline(h=center)
abline(h=lcl)
abline(h=ucl)
mtext(side=4,at=ucl,"UCL")
mtext(side=4,at=lcl,"LCL")
mtext(side=4,at=center,"Center")


## Generate moving range control chart.
lcl = mn.mr - 3*mn.mr/d2
ucl = mn.mr + 3*mn.mr/d2
plot(raw.mr, type="l", ylab="Moving range of line width")
abline(h=mn.mr)
abline(h=ucl)
abline(h=max(0,lcl))
mtext(side=4,at=ucl,"UCL")
mtext(side=4,at=max(0,lcl),"LCL")
mtext(side=4,at=mn.mr,"Center")


## Generate mean control chart (wafers).

## Compute averages and standard deviations for each cassette and wafer.
qmn = aggregate(x=raw,by=list(wafer,cassette),FUN="mean")
qsd = aggregate(x=raw,by=list(wafer,cassette),FUN="sd")

## Compute center line and control limits.
center = mean(qmn$x)
sbar = mean(qsd$x)
n = 5
c4 = 4*(n-1)/(4*n-3)
A3 = 3/(c4*sqrt(n))
ucl = center + A3*sbar
lcl = center - A3*sbar

## Generate chart.
plot(qmn$x, type="o", pch=16, ylab="Mean of line width", xlab="Wafer")
abline(h=center)
abline(h=ucl)
abline(h=lcl)
mtext(side=4,at=ucl,"UCL")
mtext(side=4,at=lcl,"LCL")
mtext(side=4,at=center,"Center")


## Generate SD control chart (wafers).

## Compute center line and upper control limit and generate chart.
ucl = sbar + 3*(sbar/c4)*sqrt(1-c4**2)
plot(qsd$x, type="o", pch=16, ylim=c(.1,.9), ylab="SD of line width",
     xlab="Wafer")
abline(h=sbar)
abline(h=ucl)
mtext(side=4,at=ucl,"UCL")
mtext(side=4,at=sbar,"Center")


## Generate mean control chart (cassettes).

## Compute averages and standard deviations for each cassette.
qmn = aggregate(x=raw,by=list(cassette),FUN="mean")
qsd = aggregate(x=raw,by=list(cassette),FUN="sd")

## Compute center line and control limits.
center = mean(qmn$x)
sbar = mean(qsd$x)
n = 15
c4 = 4*(n-1)/(4*n-3)
A3 = 3/(c4*sqrt(n))
ucl = center + A3*sbar
lcl = center - A3*sbar

## Generate chart.
plot(qmn$x, type="o", pch=16, ylab="Mean of line width", xlab="Cassette",
     ylim=c(1.5,4.5))
abline(h=center)
abline(h=ucl)
abline(h=lcl)
mtext(side=4,at=ucl,"UCL")
mtext(side=4,at=lcl,"LCL")
mtext(side=4,at=center,"Center")


## Generate SD control chart (cassettes).

## Compute center line and control limits and generate chart.
ucl = sbar + 3*(sbar/c4)*sqrt(1-c4**2)
lcl = sbar - 3*(sbar/c4)*sqrt(1-c4**2)
plot(qsd$x, type="o", pch=16, ylab="SD of line width", ylim=c(.1,.9),
     xlab="Cassette")
abline(h=sbar)
abline(h=ucl)
abline(h=lcl)
mtext(side=4,at=ucl,"UCL")
mtext(side=4,at=lcl,"LCL")
mtext(side=4,at=sbar,"Center")

## Generate the component of variance table.

## Attach necessary libraries.
library("nlme")
library("ape")

## Create data frame.
df = data.frame(raw,cassette,wafer)

## Fit the random effects model and print variance components.
z = lme(raw ~ 1, random=~1|cassette/wafer, data=df)
varcomp(z)

##>   cassette      wafer     Within 
##> 0.26452145 0.04997089 0.17549617 
##> attr(,"class")
##> [1] "varcomp"

## The "Within" component represents site variation.


## Generate mean squares.
aov(raw ~ cassette + wafer/cassette - wafer)

##> Call:
##>    aov(formula = raw ~ cassette + wafer/cassette - wafer)

##> Terms:
##>                  cassette cassette:wafer Residuals
##> Sum of Squares  127.40293       25.52089  63.17865
##> Deg. of Freedom        29             60       360

##> Residual standard error: 0.4189227 
##> Estimated effects may be unbalanced


## Generate a mean control chart using lot-to-lot variation.

## Compute averages and standard deviations for each cassette.
qmn = aggregate(x=raw,by=list(cassette),FUN="mean")
qsd = aggregate(x=raw,by=list(cassette),FUN="sd")
ql = aggregate(x=raw,by=list(cassette),FUN="length")

## Compute center line and within-lot control limits.
center = mean(qmn$x)
sbar = mean(qsd$x)
n = ql$x[1]
c4 = 4*(n-1)/(4*n-3)
A3 = 3/(c4*sqrt(n))
ucl = center + A3*sbar
lcl = center - A3*sbar

## Compute between-lot control limits.
sdybar = sd(qmn$x)
ll = center - 3*sdybar
ul = center + 3*sdybar

## Generate chart.
plot(qmn$x, type="o", pch=16, ylim=c(0,5),
     ylab="Mean of Line Width", xlab="Cassette")
abline(h=center)
abline(h=ucl)
abline(h=lcl)
abline(h=ll)
abline(h=ul)
mtext(side=4,at=ucl,"UCL")
mtext(side=4,at=lcl,"LCL")
mtext(side=4,at=ll,"Lot-to-Lot")
mtext(side=4,at=ul,"Lot-to-Lot")
