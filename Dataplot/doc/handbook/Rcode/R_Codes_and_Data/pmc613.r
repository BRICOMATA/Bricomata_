R commands and output:

## Read the data and save some variables as factors.
m = read.table("monitor-6.6.1.1.dat",skip=4)
cassette = as.factor(m[,1])
wafer = as.factor(m[,2])
site = as.factor(m[,3])
raw = m[,4]
order = m[,5]

## Moving average control chart.
library(Hmisc)
raw.mr = abs(raw - Lag(raw))
raw.ma = (raw + Lag(raw))/2

center = mean(raw.ma[2:length(raw)])
mn.mr  = mean(raw.mr[2:length(raw)])
d2 = 1.128
lcl = center - 3*mn.mr/d2
ucl = center + 3*mn.mr/d2

plot(raw.ma, ylim=c(1,5), type="l", ylab="Moving average of line width")
abline(h=center)
abline(h=lcl)
abline(h=ucl)
mtext(side=4,at=ucl,"UCL")
mtext(side=4,at=lcl,"LCL")
mtext(side=4,at=center,"Center")

## Moving range control chart.
lcl = mn.mr - 3*mn.mr/d2
ucl = mn.mr + 3*mn.mr/d2
plot(raw.mr, type="l", ylab="Moving range of line width")
abline(h=mn.mr)
abline(h=ucl)
abline(h=max(0,lcl))
mtext(side=4,at=ucl,"UCL")
mtext(side=4,at=max(0,lcl),"LCL")
mtext(side=4,at=mn.mr,"Center")


## Mean control chart for wafers.
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

## Generate control chart.
plot(qmn$x, type="o", pch=16, ylab="Mean of line width", xlab="Wafer")
abline(h=center)
abline(h=ucl)
abline(h=lcl)
mtext(side=4,at=ucl,"UCL")
mtext(side=4,at=lcl,"LCL")
mtext(side=4,at=center,"Center")

## SD control chart for wafers.
## Compute center line and upper control limit and generate chart.
ucl = sbar + 3*(sbar/c4)*sqrt(1-c4**2)
plot(qsd$x, type="o", pch=16, ylim=c(.1,.9), ylab="SD of line width",
     xlab="Wafer")
abline(h=sbar)
abline(h=ucl)
mtext(side=4,at=ucl,"UCL")
mtext(side=4,at=sbar,"Center")

## Mean control chart for cassettes.
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

## Generate control chart.
plot(qmn$x, type="o", pch=16, ylab="Mean of line width", xlab="Cassette",
     ylim=c(1.5,4.5))
abline(h=center)
abline(h=ucl)
abline(h=lcl)
mtext(side=4,at=ucl,"UCL")
mtext(side=4,at=lcl,"LCL")
mtext(side=4,at=center,"Center")

## SD control chart for cassettes.
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

## Compute component of variance.
## Attach necessary libraries.
library("nlme")
library("ape")

## Create new data frame.
df = data.frame(raw,cassette,wafer)

## Fit the random effects model and print variance components.
z = lme(raw ~ 1, random=~1|cassette/wafer, data=df)
varcomp(z)

##>   cassette      wafer     Within 
##> 0.26452145 0.04997089 0.17549617 
##> attr(,"class")
##> [1] "varcomp"

## Analysis of variance - use sums of squares and degrees 
## of freedom to manually compute variance components.
aov(raw ~ cassette + wafer/cassette - wafer)

##> Call:
##>    aov(formula = raw ~ cassette + wafer/cassette - wafer)

##> Terms:
##>                  cassette cassette:wafer Residuals
##> Sum of Squares  127.40293       25.52089  63.17865
##> Deg. of Freedom        29             60       360

##> Residual standard error: 0.4189227 
##> Estimated effects may be unbalanced

## Compute expected mean squares and variance components
## using varcompci package.
## Attach library varcompci.
library(varcompci)
X <- data.frame(c=df$cassette,w=df$wafer)
y <- raw
totvar = c("c","w")
Matrix = matrix(cbind(c(1,0),c(1,1)),ncol=2)
response = "y"
dsn = "X"
x <- varcompci(dsn=dsn, response=response, totvar=totvar, Matrix=Matrix)
summary(x)

##> Expected Mean Square
##>       EMS                                
##> c     "var(Resid) + 5var(c:w) + 15var(c)"
##> c:w   "var(Resid) + 5var(c:w)"           
##> resid "var(Resid)"                       
##> 
##> Anova of mixed model
##>        df        SS      MS        F Pval
##> c      29 127.40293 4.39320 10.32849    0
##> c:w    60  25.52089 0.42535  2.42369    0
##> resid 360  63.17865 0.17550              
##> 
##> Random and Fixed Mean Square
##>        Mean Sq 
##> c     4.3932045
##> c:w   0.4253482
##> resid 0.1754962
##> 
##> Covariance Paramater Estimate
##>       Covariance paramater
##> c               0.26452376
##> c:w             0.04997039
##> resid           0.17549624
##> 
##> Fit Statistics
##> AIC (smaller is better)  
##>                 575.5681 
##> 
##> BIC (smaller is better)  
##>                 949.5097 
##> 
##> Confidence Interval of variance components
##>       Method      LB Estimate      UB
##> c      TBGJL 0.15649  0.26452 0.50078
##> c:w    TBGJL  0.0254  0.04997 0.09113
##> resid  Exact 0.15244   0.1755 0.20424

