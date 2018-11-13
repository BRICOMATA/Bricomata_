R commands and output:

## Sonoluminescense Light Intensity Case Study.

## Read and sort data.
fname = "s:/sed/jsplett/r_handbook/data/inn.dat"
mo = matrix(scan(fname,skip=25),ncol=8,byrow=T)
m = mo[order(mo[,1]),]
y = m[,1]
x1 = m[,2]
x2 = m[,3]
x3 = m[,4]
x4 = m[,5]
x5 = m[,6]
x6 = m[,7]
x7 = m[,8]

## Attach memisc library for the recode function.
library(memisc)

## Generate re-coded factor variables for plotting.
r0 = "12345678"
r1 = recode(x1,"+" <- c(1),"-" <- c(-1))
r2 = recode(x2,"+" <- c(1),"-" <- c(-1))
r3 = recode(x3,"+" <- c(1),"-" <- c(-1))
r4 = recode(x4,"+" <- c(1),"-" <- c(-1))
r5 = recode(x5,"+" <- c(1),"-" <- c(-1))
r6 = recode(x6,"+" <- c(1),"-" <- c(-1))
r7 = recode(x7,"+" <- c(1),"-" <- c(-1))
id = paste(r1,r2,r3,r4,r5,r6,r7,sep="")
id = c(r0,id)
id12 = paste(r1,r2,sep="")
id13 = paste(r1,r3,sep="")
id14 = paste(r1,r4,sep="")
id15 = paste(r1,r5,sep="")
id16 = paste(r1,r6,sep="")
id17 = paste(r1,r7,sep="")
id23 = paste(r2,r3,sep="")
id24 = paste(r2,r4,sep="")
id25 = paste(r2,r5,sep="")
id26 = paste(r2,r6,sep="")
id27 = paste(r2,r7,sep="")
id34 = paste(r3,r4,sep="")
id35 = paste(r3,r5,sep="")
id36 = paste(r3,r6,sep="")
id37 = paste(r3,r7,sep="")
id45 = paste(r4,r5,sep="")
id46 = paste(r4,r6,sep="")
id47 = paste(r4,r7,sep="")
id56 = paste(r5,r6,sep="")
id57 = paste(r5,r7,sep="")
id67 = paste(r6,r7,sep="")

## Plot points in increasing order with labels indicating
## factor levels.
par(cex=1.25,las=3)
case = c(1:length(id))
plot(c(NA,m[,1]), xaxt = "n", col="blue", pch=19,
     main="Ordered Sonoluminescence Light Intensity Data",
     ylab="Light Intensity", xlab="")
axis(1, at=case, labels=id)

## Restructure data so that x1, x2, ... x7 are in a single column.
## Also, save re-coded version of the factor levels for the mean plot.
tempx  = x1
tempxc = x1 + 1
dm1 = cbind(y,tempx,tempxc)
tempx  = x2
tempxc = x2 + 4
dm2 = cbind(y,tempx,tempxc)
tempx  = x3
tempxc = x3 + 7
dm3 = cbind(y,tempx,tempxc)
tempx  = x4
tempxc = x4 + 10
dm4 = cbind(y,tempx,tempxc)
tempx  = x5
tempxc = x5 + 13
dm5 = cbind(y,tempx,tempxc)
tempx  = x6
tempxc = x6 + 16
dm6 = cbind(y,tempx,tempxc)
tempx  = x7
tempxc = x7 + 19
dm7 = cbind(y,tempx,tempxc)
dm8 = rbind(dm1,dm2,dm3,dm4,dm5,dm6,dm7)

## Generate factor ID variable.
n = length(y)
varind = c(rep("Molarity",n),
           rep("Solute Type",n),
           rep("pH",n),
           rep("Gas Type",n),
           rep("Water Depth",n),
           rep("Horn Depth",n),
           rep("Flask Clamping",n))
varind = as.factor(varind)

## Comute grand mean.
ybar = mean(y)

## Create a dataframe with "stacked" factors and data.
df = data.frame(dm8,varind)

## Attach lattice library and generate the DEX scatter plot.
library(lattice)
xyplot(y~tempx|varind,data=df,layout=c(4,2),xlim=c(-2,2),
       ylab="Light Intensity",xlab="Factor Levels",
       main="Scatter Plot for Sonoluminescense Light Intensity",
	 panel=function(x,y, ...){
		panel.xyplot(x,y, ...)
		panel.abline(h=ybar) }
)

## Generate mean plot.
par(cex=1,las=3)
interaction.plot(df$tempxc,df$varind,df$y,fun=mean,
                 ylab="Average Light Intensity",xlab="",
                 main="DEX Mean Plot for Sonoluminescense Light Intensity",
                 trace.label="Factor",type="b",pch=19,
                 legend=FALSE,xaxt="n")
xpos = c(1.5,3.5,5.5,7.5,9.5,11.5,13.5)
xlabel = c("Molarity","Solute","pH","Gas Type","Water",
           "Horn","Flask")
axis(side=1,at=xpos,labels=xlabel)
abline(h=ybar)


## Create dataframe with interaction factors.
x12 = x1*x2
x13 = x1*x3
x14 = x1*x4
x15 = x1*x5
x16 = x1*x6
x17 = x1*x7
x23 = x2*x3
x24 = x2*x4
x25 = x2*x5
x26 = x2*x6
x27 = x2*x7
x34 = x3*x4
x35 = x3*x5
x36 = x3*x6
x37 = x3*x7
x45 = x4*x5
x46 = x4*x6
x47 = x4*x7
x56 = x5*x6
x57 = x5*x7
x67 = x6*x7
x124 = x1*x2*x4

fx1 = factor(x1)
fx2 = factor(x2)
fx3 = factor(x3)
fx4 = factor(x4)
fx5 = factor(x5)
fx6 = factor(x6)
fx7 = factor(x7)
fx12 = factor(x12)
fx13 = factor(x13)
fx14 = factor(x14)
fx15 = factor(x15)
fx16 = factor(x16)
fx17 = factor(x17)
fx23 = factor(x23)
fx24 = factor(x24)
fx25 = factor(x25)
fx26 = factor(x26)
fx27 = factor(x27)
fx34 = factor(x34)
fx35 = factor(x35)
fx36 = factor(x36)
fx37 = factor(x37)
fx45 = factor(x45)
fx46 = factor(x46)
fx47 = factor(x47)
fx56 = factor(x56)
fx57 = factor(x57)
fx67 = factor(x67)
fx124 = factor(x124)
dfip = data.frame(y,fx1,fx2,fx3,fx4,fx5,fx6,fx7,
                  fx12,fx13,fx14,fx15,fx16,fx17,
                  fx23,fx24,fx25,fx26,fx27,
                  fx34,fx35,fx36,fx37,
                  fx45,fx46,fx47,
                  fx56,fx57,
                  fx67,fx124)

## Compute effect estimates and factor means.
fmeans = function(x,fac){
q = aggregate(x=x,by=list(fac),FUN="mean")
lo = q[1,2]
hi = q[2,2]
e = hi-lo
ret = c(lo,hi,e)
}
e1 = fmeans(dfip$y,dfip$fx1)
e2 = fmeans(dfip$y,dfip$fx2)
e3 = fmeans(dfip$y,dfip$fx3)
e4 = fmeans(dfip$y,dfip$fx4)
e5 = fmeans(dfip$y,dfip$fx5)
e6 = fmeans(dfip$y,dfip$fx6)
e7 = fmeans(dfip$y,dfip$fx7)
e12 = fmeans(dfip$y,dfip$fx12)
e13 = fmeans(dfip$y,dfip$fx13)
e14 = fmeans(dfip$y,dfip$fx14)
e15 = fmeans(dfip$y,dfip$fx15)
e16 = fmeans(dfip$y,dfip$fx16)
e17 = fmeans(dfip$y,dfip$fx17)
e23 = fmeans(dfip$y,dfip$fx23)
e24 = fmeans(dfip$y,dfip$fx24)
e25 = fmeans(dfip$y,dfip$fx25)
e26 = fmeans(dfip$y,dfip$fx26)
e27 = fmeans(dfip$y,dfip$fx27)
e34 = fmeans(dfip$y,dfip$fx34)
e35 = fmeans(dfip$y,dfip$fx35)
e36 = fmeans(dfip$y,dfip$fx36)
e37 = fmeans(dfip$y,dfip$fx37)
e45 = fmeans(dfip$y,dfip$fx45)
e46 = fmeans(dfip$y,dfip$fx46)
e47 = fmeans(dfip$y,dfip$fx47)
e56 = fmeans(dfip$y,dfip$fx56)
e57 = fmeans(dfip$y,dfip$fx57)
e67 = fmeans(dfip$y,dfip$fx67)

# Create factor labels from effect values.
e = round(rbind(e7,e6,e67,e5,e56,e57,e4,e45,e46,e47,
            e3,e34,e35,e36,e37,e2,e23,e24,e25,e26,e27,
            e1,e12,e13,e14,e15,e16,e17),1)
textlabs = c("X7 =", 
             "X6 =", "X67 =",
             "X5 =", "X56 =", "X57 =", 
             "X4 =", "X45 =", "X46 =", "X47 =",
             "X3 =", "X34 =", "X35 =", "X36 =", "X37 =",
             "X2 =", "X23 =", "X24 =", "X25 =", "X26 =", "X27 =",
             "X1 =", "X12 =", "X13 =", "X14 =", "X15 =", "X16 =", "X17 =")
labs = paste(textlabs,e[,3])
group = factor(c(1:28),labels=labs)

# Create data frame with factor level means.
x = e[,1]
xlev = rep(-1,28)
xlo = cbind(x,xlev,group)

x = e[,2]
xlev = rep(1,28)
xhi = cbind(x,xlev,group)

mm = rbind(xlo,xhi)
mm = as.data.frame(mm)

# Customize Lattice plot layout and color.
sp = c(T,T,T,T,T,T,F,
       T,T,T,T,T,F,F,
       T,T,T,T,F,F,F,
       T,T,T,F,F,F,F,
       T,T,F,F,F,F,F,
       T,F,F,F,F,F,F,
       F,F,F,F,F,F,F)
strip.bg_custom = trellis.par.get("strip.background")
strip.bg_custom$col =c("#cce6ff","#ffe5cc","#ccffcc","#ccffff","#ffccff",
                       "#ffcccc","#ffffcc")
strip.sh_custom = strip.bg_custom
trellis.par.set("strip.background", strip.bg_custom)
trellis.par.set("strip.shingle", strip.sh_custom)

trellis.par.set(list(fontsize=list(text=10)))

# Generate plot.
xyplot(x~xlev | group, data=mm, type="b", xlim=c(-2,2),
       layout=c(7,7), skip=sp, col=c(4), 
       strip = function(..., style,factor.levels,strip.levels,strip.names)
               strip.default(..., style = 1,factor.levels=labs,
                             strip.levels=c(F,T),strip.names=c(T,F)),
       xlab="Factor Level", ylab="Light Intensity", 
       main="DEX Mean Plot for Sonoluminescense Light Intensity",
panel = function(x, y, ...){
panel.xyplot(x, y, ...)
panel.abline(h = ybar, lty = 2, col = 2)
}
)



## Create dataframe with factors.
fid1 = factor(id23)
fid2 = factor(id13)
fid3 = factor(id12)
df2 = data.frame(y,fx1,fx2,fx3,fx4,fx5,fx6,fx7,
                fid1,fid2,fid3)

## Generate seven plots on one page.
par(mfrow=c(3,3),las=0)

## Generate level means.
ag = aggregate(x=df2$y,by=list(df2$fx1,df2$fx2,df2$fx3),FUN="mean")

## Recode variables for plotting.
ag1 = recode(ag$Group.1,"+" <- c(1),"-" <- c(-1))
ag2 = recode(ag$Group.2,"+" <- c(1),"-" <- c(-1))
ag3 = recode(ag$Group.3,"+" <- c(1),"-" <- c(-1))
ag12 = paste(ag1,ag2,sep="")
ag13 = paste(ag1,ag3,sep="")
ag23 = paste(ag2,ag3,sep="")
dfag = data.frame(ag$x,ag$Group.1,ag$Group.2,ag$Group.3,ag12,ag13,ag23)

## Generate the block plot for factor 1.
boxplot(dfag$ag.x ~ dfag$ag23, medlty="blank", boxwex=.5,
        ylab="Light Intensity",xlab="Factor Levels of X2,X3",
        main="Primary Factor X1", cex.main=1)
## Add points for the effects.
points(dfag$ag23[dfag$ag.Group.1==1],dfag$ag.x[dfag$ag.Group.1==1],
       pch=19,col="blue")
points(dfag$ag23[dfag$ag.Group.1==-1],dfag$ag.x[dfag$ag.Group.1==-1],
       col="blue")
## Add legend.
legend(3.25,350,c("+","-"),pch=c(19,1), col="blue", bty="o",
       x.intersp=.75, title="X1 Level", cex=.7, horiz=TRUE)

## Generate the block plot for factor 2.
boxplot(dfag$ag.x ~ dfag$ag13, medlty="blank", boxwex=.5,
        ylab="Sensitivity",xlab="Factor Levels of X1 X3",
        main="Primary Factor X2", cex.main=1)
## Add points for the effect means.
points(dfag$ag13[dfag$ag.Group.2==1],dfag$ag.x[dfag$ag.Group.2==1],
       pch=19,col="blue")
points(dfag$ag13[dfag$ag.Group.2==-1],dfag$ag.x[dfag$ag.Group.2==-1],
       col="blue")
## Add legend.
legend(.5,350,c("+","-"),pch=c(19,1), col="blue", bty="o",
       x.intersp=.75, title="X2 Level", cex=.7, horiz=TRUE)

## Generate the block plot for factor 3.
boxplot(dfag$ag.x ~ dfag$ag12, medlty="blank", boxwex=.5, 
        ylab="Sensitivity",xlab="Factor Levels of X1 X2",
        main="Primary Factor X3", cex.main=1)
## Add points for the effects.
points(dfag$ag12[dfag$ag.Group.3==1],dfag$ag.x[dfag$ag.Group.3==1],
       pch=19,col="blue")
points(dfag$ag12[dfag$ag.Group.3==-1],dfag$ag.x[dfag$ag.Group.3==-1],
       col="blue")
## Add legend.
legend(0.5,350,c("+","-"),pch=c(19,1), col="blue", bty="o",
       x.intersp=.75, title="X3 Level", cex=.7, horiz=TRUE)

## Generate level means for factor 4.
ag = aggregate(x=df2$y,by=list(df2$fx4,df2$fx1,df2$fx2),FUN="mean")

## Recode variables for plotting.
ag1 = recode(ag$Group.2,"+" <- c(1),"-" <- c(-1))
ag2 = recode(ag$Group.3,"+" <- c(1),"-" <- c(-1))
ag12 = paste(ag1,ag2,sep="")
dfag = data.frame(ag$x,ag$Group.1,ag12)

## Generate the block plot for factor 4.
boxplot(dfag$ag.x ~ dfag$ag12, medlty="blank", boxwex=.5,
        ylab="Light Intensity",xlab="Factor Levels of X1,X2",
        main="Primary Factor X4", cex.main=1)
## Add points for the effects.
points(dfag$ag12[dfag$ag.Group.1==1],dfag$ag.x[dfag$ag.Group.1==1],
       pch=19,col="blue")
points(dfag$ag12[dfag$ag.Group.1==-1],dfag$ag.x[dfag$ag.Group.1==-1],
       col="blue")
## Add legend.
legend(.5,220,c("+","-"),pch=c(19,1), col="blue", bty="o",
       x.intersp=.75, title="X4 Level", cex=.7, horiz=TRUE)

## Generate level means for factor 5.
ag = aggregate(x=df2$y,by=list(df2$fx5,df2$fx1,df2$fx2),FUN="mean")

## Recode variables for plotting.
ag1 = recode(ag$Group.2,"+" <- c(1),"-" <- c(-1))
ag2 = recode(ag$Group.3,"+" <- c(1),"-" <- c(-1))
ag12 = paste(ag1,ag2,sep="")
dfag = data.frame(ag$x,ag$Group.1,ag12)

## Generate the block plot for factor 5.
boxplot(dfag$ag.x ~ dfag$ag12, medlty="blank", boxwex=.5,
        ylab="Light Intensity",xlab="Factor Levels of X1,X2",
        main="Primary Factor X5", cex.main=1)
## Add points for the effects.
points(dfag$ag12[dfag$ag.Group.1==1],dfag$ag.x[dfag$ag.Group.1==1],
       pch=19,col="blue")
points(dfag$ag12[dfag$ag.Group.1==-1],dfag$ag.x[dfag$ag.Group.1==-1],
       col="blue")
## Add legend.
legend(.5,225,c("+","-"),pch=c(19,1), col="blue", bty="o",
       x.intersp=.75, title="X5 Level", cex=.7, horiz=TRUE)

## Generate level means for factor 6.
ag = aggregate(x=df2$y,by=list(df2$fx6,df2$fx1,df2$fx2),FUN="mean")

## Recode variables for plotting.
ag1 = recode(ag$Group.2,"+" <- c(1),"-" <- c(-1))
ag2 = recode(ag$Group.3,"+" <- c(1),"-" <- c(-1))
ag12 = paste(ag1,ag2,sep="")
dfag = data.frame(ag$x,ag$Group.1,ag12)

## Generate the block plot for factor 6.
boxplot(dfag$ag.x ~ dfag$ag12, medlty="blank", boxwex=.5,
        ylab="Light Intensity",xlab="Factor Levels of X1,X2",
        main="Primary Factor X6", cex.main=1)
## Add points for the effects.
points(dfag$ag12[dfag$ag.Group.1==1],dfag$ag.x[dfag$ag.Group.1==1],
       pch=19,col="blue")
points(dfag$ag12[dfag$ag.Group.1==-1],dfag$ag.x[dfag$ag.Group.1==-1],
       col="blue")
## Add legend.
legend(.5,225,c("+","-"),pch=c(19,1), col="blue", bty="o",
       x.intersp=.75, title="X6 Level", cex=.7, horiz=TRUE)

## Generate level means for factor 7.
ag = aggregate(x=df2$y,by=list(df2$fx7,df2$fx1,df2$fx2),FUN="mean")

## Recode variables for plotting.
ag1 = recode(ag$Group.2,"+" <- c(1),"-" <- c(-1))
ag2 = recode(ag$Group.3,"+" <- c(1),"-" <- c(-1))
ag12 = paste(ag1,ag2,sep="")
dfag = data.frame(ag$x,ag$Group.1,ag12)

## Generate the block plot for factor 7.
boxplot(dfag$ag.x ~ dfag$ag12, medlty="blank", boxwex=.5,
        ylab="Light Intensity",xlab="Factor Levels of X1,X2",
        main="Primary Factor X7", cex.main=1)
## Add points for the effects.
points(dfag$ag12[dfag$ag.Group.1==1],dfag$ag.x[dfag$ag.Group.1==1],
       pch=19,col="blue")
points(dfag$ag12[dfag$ag.Group.1==-1],dfag$ag.x[dfag$ag.Group.1==-1],
       col="blue")
## Add legend.
legend(.5,350,c("+","-"),pch=c(19,1), col="blue", bty="o",
       x.intersp=.75, title="X7 Level", cex=.7, horiz=TRUE)
par(mfrow=c(1,1))


## Generate Youden plot.

## Generate averages for each factor and level.
q1 = aggregate(x=dfip$y,by=list(dfip$fx1),FUN="mean")
qt1 = t(q1$x)
q2 = aggregate(x=dfip$y,by=list(dfip$fx2),FUN="mean")
qt2 = t(q2$x)
q3 = aggregate(x=dfip$y,by=list(dfip$fx3),FUN="mean")
qt3 = t(q3$x)
q4 = aggregate(x=dfip$y,by=list(dfip$fx4),FUN="mean")
qt4 = t(q4$x)
q5 = aggregate(x=dfip$y,by=list(dfip$fx5),FUN="mean")
qt5 = t(q5$x)
q6 = aggregate(x=dfip$y,by=list(dfip$fx6),FUN="mean")
qt6 = t(q6$x)
q7 = aggregate(x=dfip$y,by=list(dfip$fx7),FUN="mean")
qt7 = t(q7$x)
q12 = aggregate(x=dfip$y,by=list(dfip$fx12),FUN="mean")
qt12 = t(q12$x)
q13 = aggregate(x=dfip$y,by=list(dfip$fx13),FUN="mean")
qt13 = t(q13$x)
q14 = aggregate(x=dfip$y,by=list(dfip$fx14),FUN="mean")
qt14 = t(q14$x)
q15 = aggregate(x=dfip$y,by=list(dfip$fx15),FUN="mean")
qt15 = t(q15$x)
q16 = aggregate(x=dfip$y,by=list(dfip$fx16),FUN="mean")
qt16 = t(q16$x)
q17 = aggregate(x=dfip$y,by=list(dfip$fx17),FUN="mean")
qt17 = t(q17$x)
q24 = aggregate(x=dfip$y,by=list(dfip$fx24),FUN="mean")
qt24 = t(q24$x)
q124 = aggregate(x=dfip$y,by=list(dfip$fx124),FUN="mean")
qt124 = t(q124$x)

yp = rbind(qt1,qt2,qt3,qt4,qt5,qt6,qt7,
           qt12,qt13,qt14,qt15,qt16,qt17,qt24,qt124)

## Generate names for effect estimates.
z = lm(y ~ x1 + x2 + x3 + x4 + x5 + x6 + x7 +
           x12 + x13 + x14 + x15 + x16 + x17 + x24 + x124)
zz = summary(z)
effects = coef(z)[-1]*2

## Generate Youden plot.
plot(yp[,1],yp[,2], xlim=c(70,155), ylim=c(70,155),
     xlab="Average Response for -1 Settings",
     ylab="Average Response for +1 Settings",
     main="Youden Plot for Sonoluminescense Data")
text(yp[,1],yp[,2],labels=names(effects),pos=4,cex=.75)
abline(h=ybar)
abline(v=ybar)


## Save effects in decreasing order.
torder = zz$coefficients[order(abs(zz$coefficients[,1]),decreasing=TRUE),]
torder[,1]

> (Intercept)          x2          x7         x13          x1          x3 
>   110.60625   -39.30625   -39.05625    35.00625    33.10625    31.90625 
>         x17         x12         x16         x14          x6          x5 
>   -31.73125   -29.78125    -8.16875    -5.24375    -4.51875     3.74375 
>        x124          x4         x24         x15 
>     2.91875     1.85625     0.84375    -0.28125 

yvar = torder[-1,1]*2
lvar16 = rownames(torder)
lvar = lvar16[-1]
xvar = c(1:length(lvar))

## Plot absolute values of effects in decreasing order.
plot(xvar,abs(yvar), xlim=c(1,16), 
     main = "Sonoluminescent Light Intensity",
     ylab="|Effect|", xlab="", xaxt="n")
text(xvar,abs(yvar), labels=lvar, pos=4, cex=.8)


## Generate half-normal probability plot of effect estimates.
library(faraway)
halfnorm(effects,nlab=length(effects), cex=.8,
         labs=names(effects),
         ylab="Ordered |Effects|",
         main="Half-Normal Probability Plot of Sonoluminescent Data")


## Compute the residual standard deviation for cumulative
## models (mean plus cumulative terms).
z = lm(y ~ 1)
ese = summary(z)$sigma

z = update(z, . ~ . + x2)
se1 = summary(z)$sigma

z = update(z, . ~ . + x7)
se2 = summary(z)$sigma

z = update(z, . ~ . + x13)
se3 = summary(z)$sigma

z = update(z, . ~ . + x1)
se4 = summary(z)$sigma

z = update(z, . ~ . + x3)
se5 = summary(z)$sigma

z = update(z, . ~ . + x17)
se6 = summary(z)$sigma

z = update(z, . ~ . + x12)
se7 = summary(z)$sigma

z = update(z, . ~ . + x16)
se8 = summary(z)$sigma

z = update(z, . ~ . + x14)
se9 = summary(z)$sigma

z = update(z, . ~ . + x6)
se10 = summary(z)$sigma

z = update(z, . ~ . + x5)
se11 = summary(z)$sigma

z = update(z, . ~ . + x124)
se12 = summary(z)$sigma

z = update(z, . ~ . + x4)
se13 = summary(z)$sigma

z = update(z, . ~ . + x24)
se14 = summary(z)$sigma

z = update(z, . ~ . + x15)
se15 = summary(z)$sigma

Eff.SE = rbind(ese,se1,se2,se3,se4,se5,se6,se7,se8,se9,
               se10,se11,se12,se13,se14,se15)

## Plot residual standard deviation for cummulative models.
plot(Eff.SE, main = "Sonoluminescent Light Intensity",
     ylab="Cummulative Residual Standard Deviation", xlab="Additional Term", 
     xaxt="n")
text(c(1:length(Eff.SE)) ,Eff.SE, labels=lvar16, pos=4, cex=.8)

## Generate level means for plotting.
q = aggregate(x=dfip$y,by=list(dfip$fx2,dfip$fx7),FUN="mean")
qv1 = as.vector(q$Group.1,mode="numeric")-1
qv2 = as.vector(q$Group.2,mode="numeric")-1
qv1[qv1==0] = -1
qv2[qv2==0] = -1

## Contour plot y(x7),x(x2)
## Generate x and y data for plotting.
xord = seq(-2,2,by=.1)
yord = seq(-2,2,by=.1)

## Fit model with two factors, x2 and x7, and their interaction 
## for predicting the surface.
z = lm(y ~ 1 + x2 + x7 + x27)

## Generate predicted response surface and generate matrix of surface.
model = function (a, b){
  z$coefficients[1] +
  z$coefficients[2]*a +
  z$coefficients[3]*b +
  z$coefficients[4]*a*b}
pmatu = outer(xord,yord,model)

## Generate contour plot, add design points and labels.
contour(xord, yord, pmatu, nlevels=15, main="Contour Plot",
        xlab="x2", ylab="x7", col="blue")
points(qv1,qv2,pch=19)
text(c(qv1[1],qv1[3]),c(qv2[1],qv2[3]),labels=c(q$x[1],q$x[3]),pos=2)
text(c(qv1[2],qv1[4]),c(qv2[2],qv2[4]),labels=c(q$x[2],q$x[4]),pos=4)
lines(c(-1,1,1,-1,-1),c(-1,-1,1,1,-1))






