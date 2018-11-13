R commands and output:

## Eddy Current Probe Sensitivity Case Study

## Read and sort data.
mo = matrix(scan("splett3.dat",skip=25),ncol=5,byrow=T)
m = mo[order(mo[,1]),]
y = m[,1]
x1 = m[,2]
x2 = m[,3]
x3 = m[,4]

## Attach memisc library for the recode function.
library(memisc)

## Generate re-coded factor variables for plotting.
r1 = recode(x1,"+" <- c(1),"-" <- c(-1))
r2 = recode(x2,"+" <- c(1),"-" <- c(-1))
r3 = recode(x3,"+" <- c(1),"-" <- c(-1))
id = paste(r1,r2,r3,sep="")
id1 = paste(r2,r3,sep="")
id2 = paste(r1,r3,sep="")
id3 = paste(r1,r2,sep="")

## Plot points in increasing order with labels indicating
## factor levels.
par(bg=rgb(1,1,0.8),mfrow=c(1,1), cex=1.2)
case = c(1:length(id))
plot(m[,1], xaxt = "n", col="blue", pch=19,
     main="Ordered Data Plot for Eddy Current Study",
     ylab="Sensitivity", xlab="Settings of X1 X2 X3")
axis(1, at=case, labels=id)

## Restructure data so that x1, x2, and x3 are in a single column.
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
dm4 = rbind(dm1,dm2,dm3)

## Generate factor ID variable.
n = length(y)
varind = c(rep("Number of Turns",n),rep("Winding Distance",n),
           rep("Wire Gauge",n))
varind = as.factor(varind)

## Create a dataframe with "stacked" factors and data.
df = data.frame(dm4,varind)

## Attach lattice library and generate the DOE scatter plot.
par(bg=rgb(1,1,0.8),mfrow=c(1,1), cex=1.2)
library(lattice)
xyplot(y~tempx|varind,data=df,layout=c(3,1),xlim=c(-2,2), pch=19,
       ylab="Sensitivity",xlab="Factor Levels",
       main="DOE Scatter Plot for Eddy Current Data")

## Comute grand mean.
ybar = mean(y)

## Generate mean plot.
par(bg=rgb(1,1,0.8),mfrow=c(1,1), cex=1.2)
interaction.plot(df$tempxc,df$varind,df$y,fun=mean,
                 ylab="Sensitivity",xlab="",
                 main="DOE Mean Plot for Eddy Current Data",
                 trace.label="Factor",type="b",pch=19,
                 legend=FALSE,xaxt="n")
xpos = c(1.5,3.5,5.5)
xlabel = c("Number of Turns","Winding Distance","Wire Gauge")
axis(side=1,at=xpos,labels=xlabel)
abline(h=ybar)

## Create dataframe with interaction factors.
x12 = x1*x2
x13 = x1*x3
x23 = x2*x3
x123 = x1*x2*x3
fx1 = factor(x1)
fx2 = factor(x2)
fx3 = factor(x3)
fx12 = factor(x12)
fx13 = factor(x13)
fx23 = factor(x23)
fx123 = factor(x123)
dfip = data.frame(y,fx1,fx2,fx3,fx12,fx13,fx23,fx123)

## Compute effect estimates and factor means.
q = aggregate(x=dfip$y,by=list(dfip$fx1),FUN="mean")
x1lo = q[1,2]
x1hi = q[2,2]
e1 = x1lo-x1hi

q = aggregate(x=dfip$y,by=list(dfip$fx2),FUN="mean")
x2lo = q[1,2]
x2hi = q[2,2]
e2 = x2lo - x2hi

q = aggregate(x=dfip$y,by=list(dfip$fx3),FUN="mean")
x3lo = q[1,2]
x3hi = q[2,2]
e3 = x3lo - x3hi

q = aggregate(x=dfip$y,by=list(dfip$fx12),FUN="mean")
x12lo = q[1,2]
x12hi = q[2,2]
e12 = x12lo - x12hi

q = aggregate(x=dfip$y,by=list(dfip$fx13),FUN="mean")
x13lo = q[1,2]
x13hi = q[2,2]
e13 = x13lo - x13hi

q = aggregate(x=dfip$y,by=list(dfip$fx23),FUN="mean")
x23lo = q[1,2]
x23hi = q[2,2]
e23 = x23lo - x23hi

# Create factor labels from effect values.
e = round(c(e3,e2,e23,e1,e12,e13),2)
textlabs = c("X3 Effect =","X2 Effect =","X2*X3 Effect =",
             "X1 Effect =","X1*X2 Effect =","X1*X3 Effect =")
labs = paste(textlabs,e)
group = factor(c(1:6),labels=labs)

# Create data frame with factor level means.
x = c(x3lo,x2lo,x23lo,x1lo,x12lo,x13lo)
xlev = rep(-1,6)
xlo = cbind(x,xlev,group)

x = c(x3hi,x2hi,x23hi,x1hi,x12hi,x13hi)
xlev = rep(1,6)
xhi = cbind(x,xlev,group)

m = rbind(xlo,xhi)
m = as.data.frame(m)

# Customize Lattice plot layout and color.
sp = c(T,T,F,T,F,F,F,F,F)
strip.bg_custom = trellis.par.get("strip.background")
strip.bg_custom$col =c("#cce6ff","#ffe5cc","#ccffcc","#ccffff","#ffccff",
                       "#ffcccc","#ffffcc")
strip.sh_custom = strip.bg_custom
trellis.par.set("strip.background", strip.bg_custom)
trellis.par.set("strip.shingle", strip.sh_custom)

# Generate plot.
xyplot(x~xlev | group, data=m, type="b", xlim=c(-2,2),
       layout=c(3,3), skip=sp, col=c(4), pch=19,
       strip = function(..., style,factor.levels,strip.levels,strip.names)
               strip.default(..., style = 1,factor.levels=labs,
                             strip.levels=c(F,T),strip.names=c(T,F)),
       xlab="Factor Level", ylab="Sensitivity", 
       main="DOE Interaction Plot for Eddy Current Data",
panel = function(x, y, ...){
panel.xyplot(x, y, ...)
panel.abline(h = ybar, lty = 2, col = 2)
}
)

## Create dataframe with factors.
fx1 = factor(x1)
fx2 = factor(x2)
fx3 = factor(x3)
fid1 = factor(id1)
fid2 = factor(id2)
fid3 = factor(id3)
df2 = data.frame(y,fx1,fx2,fx3,fid1,fid2,fid3)

## Generate four plots on one page.
par(bg=rgb(1,1,0.8),mfrow=c(2,2),cex=1)

## Generate the block plot for factor 1 - number of turns.
boxplot(df2$y ~ df2$fid1, medlty="blank", boxwex=.5,
        ylab="Sensitivity",xlab="Factor Levels of X2 X3",
        main="Primary Factor X1", cex.main=1)
## Add points for the effects.
points(df2$fid1[df2$fx1==1],df2$y[df2$fx1==1],pch=19,col="blue")
points(df2$fid1[df2$fx1==-1],df2$y[df2$fx1==-1],col="blue")
## Add legend.
legend(0.35,1.5,c("+","-"),pch=c(19,1), col="blue", bty="o",
       x.intersp=.75, title="X1 Level", cex=.7, horiz=TRUE)

## Generate the block plot for factor 2 - winding distance.
boxplot(df2$y ~ df2$fid2, medlty="blank", boxwex=.5,
        ylab="Sensitivity",xlab="Factor Levels of X1 X3",
        main="Primary Factor X2", cex.main=1)
## Add points for the effect means.
points(df2$fid2[df2$fx2==1],df2$y[df2$fx2==1],pch=19,col="blue")
points(df2$fid2[df2$fx2==-1],df2$y[df2$fx2==-1],col="blue")
## Add legend.
legend(0.35,4.7,c("+","-"),pch=c(19,1), col="blue", bty="o",
       x.intersp=.75, title="X2 Level", cex=.7, horiz=TRUE)

## Generate the block plot for factor 3 - wire gauge.
boxplot(df2$y ~ df2$fid3, medlty="blank", boxwex=.5, 
        ylab="Sensitivity",xlab="Factor Levels of X1 X2",
        main="Primary Factor X3", cex.main=1)
## Add points for the effects.
points(df2$fid3[df2$fx3==1],df2$y[df2$fx3==1],pch=19,col="blue")
points(df2$fid3[df2$fx3==-1],df2$y[df2$fx3==-1],col="blue")
## Add legend.
legend(0.35,4.7,c("+","-"),pch=c(19,1), col="blue", bty="o",
       x.intersp=.75, title="X3 Level", cex=.7, horiz=TRUE)
par(mfrow=c(1,1))


## Re-enter data for Yates' analysis. 
m = matrix(scan("splett3.dat",skip=25),ncol=5,byrow=T)
y = m[,1]
x1 = m[,2]
x2 = m[,3]
x3 = m[,4]

## Compute the pseudo-replication standard deviation 
## (assuming all 3rd order and higher interactions are 
## really due to random error).
z = lm(y ~ 1 + x1 + x2 + x3 + x1*x2 + x1*x3 + x2*x3)
summary(z)$sigma

> [1] 0.2015254

## Save t-values based on pseudo-replication standard deviation.
t1 = summary(z)$coefficients[2,3]
t2 = summary(z)$coefficients[3,3]
t23 = summary(z)$coefficients[7,3]
t13 = summary(z)$coefficients[6,3]
t3 = summary(z)$coefficients[4,3]
t123 = 1
t12 = summary(z)$coefficients[5,3]
Tvalue = round(rbind(NaN,t1,t2,t23,t13,t3,t123,t12),2)

## Compute the effect estimate and residual standard deviation
## for each model (mean plus the effect).
z = lm(y ~ 1)
avg = summary(z)$coefficients[1]
ese = summary(z)$sigma

z = lm(y ~ 1 + x1)
e1 = summary(z)$coefficients[2]
e1se = summary(z)$sigma

z = lm(y ~ 1 + x2)
e2 = summary(z)$coefficients[2]
e2se = summary(z)$sigma

z = lm(y ~ 1 + x2:x3)
e23 = summary(z)$coefficients[2]
e23se = summary(z)$sigma

z = lm(y ~ 1 + x1:x3)
e13 = summary(z)$coefficients[2]
e13se = summary(z)$sigma

z = lm(y ~ 1 + x3)
e3 = summary(z)$coefficients[2]
e3se = summary(z)$sigma

z = lm(y ~ 1 + x1:x2:x3)
e123 = summary(z)$coefficients[2]
e123se = summary(z)$sigma

z = lm(y ~ 1 + x1:x2)
e12 = summary(z)$coefficients[2]
e12se = summary(z)$sigma

Effect = rbind(avg,e1,e2,e23,e13,e3,e123,e12)
Eff.SE = rbind(ese,e1se,e2se,e23se,e13se,e3se,e123se,e12se)

## Compute the residual standard deviation for cumulative
## models (mean plus cumulative terms).

z = lm(y ~ 1)
ce = summary(z)$sigma
z = lm(y ~ 1 + x1)
ce1 = summary(z)$sigma
z = lm(y ~ 1 + x1 + x2)
ce2 = summary(z)$sigma
z = lm(y ~ 1 + x1 + x2 + x2:x3)
ce3 = summary(z)$sigma
z = lm(y ~ 1 + x1 + x2 + x2:x3 + x1:x3)
ce4 = summary(z)$sigma
z = lm(y ~ 1 + x1 + x2 + x2:x3 + x1:x3 + x3)
ce5 = summary(z)$sigma
z = lm(y ~ x1 + x2 + x2:x3 + x1:x3 + x3 + x1:x2:x3)
ce6 = summary(z)$sigma
z = lm(y ~ 1 + x1*x2*x3)
ce7 = summary(z)$sigma

Cum.Eff = rbind(ce,ce1,ce2,ce3,ce4,ce5,ce6,ce7)

## Combine the results into a dataframe.
round(data.frame(Effect, Tvalue, Eff.SE, Cum.Eff),5)

>        Effect Tvalue  Eff.SE Cum.Eff
> avg   2.65875    NaN 1.74106 1.74106
> e1    1.55125  21.77 0.57272 0.57272
> e2   -0.43375  -6.09 1.81264 0.30429
> e23   0.14875   2.09 1.87270 0.26737
> e13   0.12375   1.74 1.87513 0.23341
> e3    0.10625   1.49 1.87656 0.19121
> e123  0.07125   1.00 1.87876 0.18031
> e12   0.06375   0.89 1.87912     NaN

## Compute effect estimates and print.
z = lm(y ~ 1 + x1 + x2 + x3 + x1*x2 + x1*x3 + x2*x3 + x1*x2*x3)
effects = coef(z)
effects

> (Intercept)         x1          x2          x3       x1:x2       x1:x3 
>    2.65875     1.55125    -0.43375     0.10625     0.06375     0.12375 
>      x2:x3    x1:x2:x3 
>    0.14875     0.07125

## Generate half-normal probability plot of effect estimates.
par(bg=rgb(1,1,0.8),mfrow=c(1,1), cex=1.2)
qqnorm((effects[-1]), pch=19, col="blue",
         main="Normal Probability Plot of Eddy Current Data")

## Generate Youden plot.
## Create dataframe with interaction factors.
x12 = x1*x2
x13 = x1*x3
x23 = x2*x3
x123 = x1*x2*x3
fx1 = factor(x1)
fx2 = factor(x2)
fx3 = factor(x3)
fx12 = factor(x12)
fx13 = factor(x13)
fx23 = factor(x23)
fx123 = factor(x123)
dfip = data.frame(y,fx1,fx2,fx3,fx12,fx13,fx23,fx123)

## Generate averages for each factor and level.
q1 = aggregate(x=dfip$y,by=list(dfip$fx1),FUN="mean")
qt1 = t(q1$x)
q2 = aggregate(x=dfip$y,by=list(dfip$fx2),FUN="mean")
qt2 = t(q2$x)
q3 = aggregate(x=dfip$y,by=list(dfip$fx3),FUN="mean")
qt3 = t(q3$x)
q4 = aggregate(x=dfip$y,by=list(dfip$fx12),FUN="mean")
qt4 = t(q4$x)
q5 = aggregate(x=dfip$y,by=list(dfip$fx13),FUN="mean")
qt5 = t(q5$x)
q6 = aggregate(x=dfip$y,by=list(dfip$fx23),FUN="mean")
qt6 = t(q6$x)
q7 = aggregate(x=dfip$y,by=list(dfip$fx23),FUN="mean")
qt7 = t(q7$x)
yp = rbind(qt1,qt2,qt3,qt4,qt5,qt6,qt7)
yp

>        [,1]   [,2]
> [1,] 1.1075 4.2100
> [2,] 3.0925 2.2250
> [3,] 2.5525 2.7650
> [4,] 2.5950 2.7225
> [5,] 2.5350 2.7825
> [6,] 2.5100 2.8075
> [7,] 2.5100 2.8075

## Generate plot.
par(bg=rgb(1,1,0.8),mfrow=c(1,1), cex=1.2)
plot(yp[,1],yp[,2], xlim=c(1,5), ylim=c(1,5),
     xlab="Average Response for -1 Settings",
     ylab="Average Response for +1 Settings",
     main="Youden Plot for Eddy Current Data")
text(yp[,1],yp[,2],labels=names(effects[-1]),pos=4)

## Fit model with x1 and x2.
z = lm(y ~ 1 + x1 + x2)
summary(z)

> Call:
> lm(formula = y ~ 1 + x1 + x2)
> 
> Residuals:
>        1        2        3        4        5        6        7        8 
>  0.15875 -0.07375 -0.12375 -0.38625 -0.03125 -0.05375 -0.00375  0.51375 
> 
> Coefficients:
>             Estimate Std. Error t value Pr(>|t|)    
> (Intercept)   2.6587     0.1076  24.714 2.02e-06 ***
> x1            1.5512     0.1076  14.419 2.89e-05 ***
> x2           -0.4337     0.1076  -4.032     0.01 *  
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
> 
> Residual standard error: 0.3043 on 5 degrees of freedom
> Multiple R-squared: 0.9782,     Adjusted R-squared: 0.9695 
> F-statistic: 112.1 on 2 and 5 DF,  p-value: 7.031e-05 

## Predict value for x1=-1 and x2 = -1.
predict(z,data.frame(x1=-1,x2=-1))

>       1 
> 1.54125

## Print residuals.
res = data.frame(x1,x2,x3,y,predict(z),z$residuals)
names(res)=c("x1","x2","x3","Observed","Predicted","Residual")
res

>   x1 x2 x3 Observed Predicted Residual
> 1 -1 -1 -1     1.70   1.54125  0.15875
> 2  1 -1 -1     4.57   4.64375 -0.07375
> 3 -1  1 -1     0.55   0.67375 -0.12375
> 4  1  1 -1     3.39   3.77625 -0.38625
> 5 -1 -1  1     1.51   1.54125 -0.03125
> 6  1 -1  1     4.59   4.64375 -0.05375
> 7 -1  1  1     0.67   0.67375 -0.00375
> 8  1  1  1     4.29   3.77625  0.51375

## Generate residual plots.
par(bg=rgb(1,1,0.8),mfrow=c(3,3), pch=19, cex=.7)
rlab = "Residual"
qqnorm(z$residuals)
plot(z$residuals,type="l",main="Run Sequence",ylab=rlab)
plot(x1,z$residuals,ylab=rlab,xlim=c(-2,2))
plot(x2,z$residuals,ylab=rlab,xlim=c(-2,2))
plot(x3,z$residuals,ylab=rlab,xlim=c(-2,2))
plot(x1*x2,z$residuals,ylab=rlab,xlim=c(-2,2))
plot(x1*x3,z$residuals,ylab=rlab,xlim=c(-2,2))
plot(x2*x3,z$residuals,ylab=rlab,xlim=c(-2,2))
plot(x1*x2*x3,z$residuals,ylab=rlab,xlim=c(-2,2))
par(mfrow=c(1,1))

## Generate level means for plotting.
q = aggregate(x=dfip$y,by=list(dfip$fx1,dfip$fx2),FUN="mean")
qv1 = as.vector(q$Group.1,mode="numeric")-1
qv2 = as.vector(q$Group.2,mode="numeric")-1
qv1[qv1==0] = -1
qv2[qv2==0] = -1

## Contour plot y(x1=number of turns),x(x2= winding distance)
## Generate x and y data for plotting.
xord = seq(-2,2,by=.1)
yord = seq(-2,2,by=.1)

## Generate predicted response surface and generate matrix of surface.
model = function (a, b){
  z$coefficients[1] +
  z$coefficients[2]*a +
  z$coefficients[3]*b}
pmatu = outer(xord,yord,model)

## Generate contour plot, add design points and labels.
par(bg=rgb(1,1,0.8),mfrow=c(1,1), cex=1.2)
contour(xord, yord, pmatu, nlevels=30, main="Contour Plot",
        xlab="Winding Distance", ylab="Number of Turns",
        col="blue")
points(qv1,qv2,pch=19)
text(c(qv1[1],qv1[3]),c(qv2[1],qv2[3]),labels=c(q$x[1],q$x[3]),pos=2)
text(c(qv1[2],qv1[4]),c(qv2[2],qv2[4]),labels=c(q$x[2],q$x[4]),pos=4)
lines(c(-1,1,1,-1,-1),c(-1,-1,1,1,-1))
