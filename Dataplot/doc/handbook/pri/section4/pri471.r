R commands and output:

## Read data and save relevant variables.
m = matrix(scan("ceramic.dat",skip=1),ncol=7,byrow=T)
strength = m[,6]
order = m[,7]

## Save variables as factors.
speed = as.factor(m[,1])
rate = as.factor(m[,2])
grit = as.factor(m[,3])
direction = as.factor(m[,4])
batch = as.factor(m[,5])

## Save numeric variables and interactions.
s = m[,1]
r = m[,2]
g = m[,3]
d = m[,4]
b = m[,5]
db = d*b
gd = g*d
gb = g*b
rg = r*g
rd = r*d
rb = r*b
sr = s*r
sg = s*g
ds = s*d
sb = s*b

df = data.frame(speed,rate,grit,direction,batch,strength,order,
     s,r,g,d,b,db,gd,gb,rg,rd,rb,sr,sg,ds,sb)
df[,1:7]

##>    speed rate grit direction batch strength order
##> 1     -1   -1   -1        -1    -1   680.45    17
##> 2      1   -1   -1        -1    -1   722.48    30
##> 3     -1    1   -1        -1    -1   702.14    14
##> 4      1    1   -1        -1    -1   666.93     8
##> 5     -1   -1    1        -1    -1   703.67    32
##> 6      1   -1    1        -1    -1   642.14    20
##> 7     -1    1    1        -1    -1   692.98    26
##> 8      1    1    1        -1    -1   669.26    24
##> 9     -1   -1   -1         1    -1   491.58    10
##> 10     1   -1   -1         1    -1   475.52    16
##> 11    -1    1   -1         1    -1   478.76    27
##> 12     1    1   -1         1    -1   568.23    18
##> 13    -1   -1    1         1    -1   444.72     3
##> 14     1   -1    1         1    -1   410.37    19
##> 15    -1    1    1         1    -1   428.51    31
##> 16     1    1    1         1    -1   491.47    15
##> 17    -1   -1   -1        -1     1   607.34    12
##> 18     1   -1   -1        -1     1   620.80     1
##> 19    -1    1   -1        -1     1   610.55     4
##> 20     1    1   -1        -1     1   638.04    23
##> 21    -1   -1    1        -1     1   585.19     2
##> 22     1   -1    1        -1     1   586.17    28
##> 23    -1    1    1        -1     1   601.67    11
##> 24     1    1    1        -1     1   608.31     9
##> 25    -1   -1   -1         1     1   442.90    25
##> 26     1   -1   -1         1     1   434.41    21
##> 27    -1    1   -1         1     1   417.66     6
##> 28     1    1   -1         1     1   510.84     7
##> 29    -1   -1    1         1     1   392.11     5
##> 30     1   -1    1         1     1   343.22    13
##> 31    -1    1    1         1     1   385.52    22
##> 32     1    1    1         1     1   446.73    29


## Generate four plots.
par(bg=rgb(1,1,0.8), mfrow=c(2,2))
qqnorm(strength)
qqline(strength, col = 2)
boxplot(strength, horizontal=TRUE, main="Box Plot", xlab="Strength")
hist(strength, main="Histogram", xlab="Strength")
plot(order, strength, xlab="Actual Run Order", ylab="Strength",
     main="Run Order Plot")
par(mfrow=c(1,1))


par(bg=rgb(1,1,0.8),mfrow=c(2,3))
boxplot(strength~speed, data=df, main="Strength by Table Speed",
        xlab="Table Speed",ylab="Strength")

boxplot(strength~rate, data=df, main="Strength by Feed Rate",
        xlab="Feed Rate",ylab="Strength")

boxplot(strength~grit, data=df, main="Strength by Wheel Grit",
        xlab="Wheel Grit",ylab="Strength")

boxplot(strength~direction, data=df, main="Strength by Direction",
        xlab="Direction",ylab="Strength")

boxplot(strength~batch, data=df, main="Strength by Batch",
        xlab="Batch",ylab="Strength")
par(mfrow=c(1,1))


## Fit a model with up to third order interactions.
q = aov(strength~(speed+rate+grit+direction+batch)^3,data=df)
summary(q)

##>                       Df Sum Sq Mean Sq  F value    Pr(>F)    
##> speed                  1    894     894   2.8175 0.1442496    
##> rate                   1   3497    3497  11.0175 0.0160190 *  
##> grit                   1  12664   12664  39.8964 0.0007354 ***
##> direction              1 315133  315133 992.7901 6.790e-08 ***
##> batch                  1  33654   33654 106.0229 4.901e-05 ***
##> speed:rate             1   4873    4873  15.3505 0.0078202 ** 
##> speed:grit             1   1839    1839   5.7928 0.0528018 .  
##> rate:grit              1    307     307   0.9686 0.3630334    
##> speed:direction        1   1637    1637   5.1578 0.0635727 .  
##> rate:direction         1   1973    1973   6.2148 0.0469744 *  
##> grit:direction         1   3158    3158   9.9500 0.0197054 *  
##> speed:batch            1    465     465   1.4651 0.2716372    
##> rate:batch             1    199     199   0.6274 0.4584725    
##> grit:batch             1     29      29   0.0925 0.7713116    
##> direction:batch        1   1329    1329   4.1863 0.0867147 .  
##> speed:rate:grit        1    357     357   1.1248 0.3296948    
##> speed:rate:direction   1   5896    5896  18.5735 0.0050391 ** 
##> speed:grit:direction   1      2       2   0.0067 0.9375734    
##> rate:grit:direction    1     44      44   0.1401 0.7210076    
##> speed:rate:batch       1    145     145   0.4559 0.5246982    
##> speed:grit:batch       1     30      30   0.0957 0.7675714    
##> rate:grit:batch        1     26      26   0.0806 0.7860488    
##> speed:direction:batch  1    545     545   1.7156 0.2381676    
##> rate:direction:batch   1    167     167   0.5271 0.4951683    
##> grit:direction:batch   1     32      32   0.1023 0.7599685    
##> Residuals              6   1905     317                       
##> ---
##> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 


## Stepwise regression based on AIC.
sreg = step(q,direction="backward")
summary(sreg)

##>                       Df Sum Sq Mean Sq   F value    Pr(>F)    
##> speed                  1    894     894    5.1873 0.0418622 *  
##> rate                   1   3497    3497   20.2845 0.0007218 ***
##> grit                   1  12664   12664   73.4537 1.845e-06 ***
##> direction              1 315133  315133 1827.8368 1.742e-14 ***
##> batch                  1  33654   33654  195.1999 8.732e-09 ***
##> speed:rate             1   4873    4873   28.2620 0.0001834 ***
##> speed:grit             1   1839    1839   10.6652 0.0067561 ** 
##> speed:direction        1   1637    1637    9.4962 0.0095099 ** 
##> speed:batch            1    465     465    2.6974 0.1264405    
##> rate:grit              1    307     307    1.7833 0.2065205    
##> rate:direction         1   1973    1973   11.4421 0.0054417 ** 
##> rate:batch             1    199     199    1.1551 0.3036160    
##> grit:direction         1   3158    3158   18.3190 0.0010689 ** 
##> direction:batch        1   1329    1329    7.7075 0.0167669 *  
##> speed:rate:grit        1    357     357    2.0709 0.1756988    
##> speed:rate:direction   1   5896    5896   34.1959 7.866e-05 ***
##> speed:rate:batch       1    145     145    0.8394 0.3776229    
##> speed:direction:batch  1    545     545    3.1587 0.1008550    
##> rate:direction:batch   1    167     167    0.9704 0.3440214    
##> Residuals             12   2069     172                        
##> ---
##> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

## Remove non-significant terms from the stepwise model.
redmod = aov(formula = strength ~ speed + rate + grit + direction + 
            batch + speed:rate + speed:grit + speed:direction +  
            rate:direction + grit:direction + direction:batch + 
            speed:rate:direction, data = df)
summary(redmod)

##>                      Df Sum Sq Mean Sq   F value    Pr(>F)    
##> speed                 1    894     894    3.9942 0.0601705 .  
##> rate                  1   3497    3497   15.6191 0.0008548 ***
##> grit                  1  12664   12664   56.5595 4.144e-07 ***
##> direction             1 315133  315133 1407.4388 < 2.2e-16 ***
##> batch                 1  33654   33654  150.3044 1.803e-10 ***
##> speed:rate            1   4873    4873   21.7618 0.0001688 ***
##> speed:grit            1   1839    1839    8.2122 0.0098962 ** 
##> speed:direction       1   1637    1637    7.3121 0.0140648 *  
##> rate:direction        1   1973    1973    8.8105 0.0078974 ** 
##> grit:direction        1   3158    3158   14.1057 0.0013383 ** 
##> direction:batch       1   1329    1329    5.9348 0.0248592 *  
##> speed:rate:direction  1   5896    5896   26.3309 5.934e-05 ***
##> Residuals            19   4254     224                        
##> ---
##> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1


## Print adjusted R squared.
summary.lm(redmod)$adj.r.squared

##> [1] 0.9822389
 

## Fit a model with all effects.
q = aov(strength~(speed+rate+grit+direction+batch)^5,data=df)

## Save effects in a vector, but remove intercept.
qef = q$effects
qef = qef[-1]

## Sort effects and save labels.
sef = qef[order(qef)]
qlab = names(sef)

## Leave off the two largest effects, Direction and Batch.
large = c(1,2)
sef = sef[-large]
qlab = qlab[-large]

## Generate theoretical quantiles.
ip = ppoints(length(sef))
zp = qnorm(ip)

## Generate normal probability plot of all effects (excluding the
## intercept).  Direction and batch are not shown.
par(bg=rgb(1,1,0.8))
plot(zp,sef, ylim=c(-120,70), xlim=c(-2,3),
     ylab="Effect", xlab="Theoretical Quantiles",
     main="Normal Probability Plot of Saturated Model Effects")
qqline(sef, col=2)
abline(h=0, col=4)
text(-2,90,"Direction and Batch not shown",pos=4)

## Add labels for largest 10 effects (two are not shown.
small = c(6:(length(sef)-3))
small2 = c((length(sef)-4):(length(sef)-3))
text(zp[-small],sef[-small],label=qlab[-small],pos=4,cex=0.8)
text(zp[small2],sef[small2],label=qlab[small2],pos=2,cex=0.8)
par(mfrow=c(1,1))


## Plot residuals versus predicted response.
par(bg=rgb(1,1,0.8))
plot(predict(redmod),redmod$residuals,ylab="Residual",
     xlab="Predicted Strength")
abline(h=0)
par(mfrow=c(1,1))

## Generate four plots.
par(mfrow=c(2,2),bg=rgb(1,1,0.8))
qqnorm(redmod$residuals)
qqline(redmod$residuals, col = 2)
abline(h=0)
boxplot(redmod$residuals, horizontal=TRUE, main="Box Plot", xlab="Residual")
hist(redmod$residuals, main="Histogram", xlab="Residual")
plot(order, redmod$residuals, xlab="Actual Run Order", ylab="Residual",
     main="Run Order Plot")
par(mfrow=c(1,1))


## Find the optimal Box-Cox transformation based on the 12 term model.
library(MASS)
par(bg=rgb(1,1,0.8))
bc = boxcox(redmod)
title("Box-Cox Transformation")
lambda = bc$x[which.max(bc$y)]
lambda
##> [1] 0.2626263

## Use lambda = 0.2 to match output in the page.
lambda = 0.2

par(mfrow=c(1,1))

## The optimum is found at lambda = 0.26.  A new variable, newstrength,
## is calculated and added to the data frame. 

## Attach psych library to compute the geometric mean of strength.
library(psych)

## Generate new transformed response variable and add to data frame.
newstrength = (strength^lambda - 1)/
              (lambda*(geometric.mean(strength)^(lambda-1)))
df =  data.frame(df,newstrength)


## Fit 12-term model with transformed strength variable.
summary(aov(formula = newstrength ~ speed + rate + grit + direction + 
            batch + speed:rate + speed:grit + speed:direction +  
            rate:direction + grit:direction + direction:batch + 
            speed:rate:direction, data = df))

##>                     Df Sum Sq Mean Sq   F value    Pr(>F)    
##> speed                 1   1068    1068    5.4268 0.0310118 *  
##> rate                  1   4374    4374   22.2261 0.0001509 ***
##> grit                  1  14998   14998   76.2175 4.472e-08 ***
##> direction             1 315356  315356 1602.6361 < 2.2e-16 ***
##> batch                 1  32505   32505  165.1893 8.059e-11 ***
##> speed:rate            1   6697    6697   34.0362 1.279e-05 ***
##> speed:grit            1   1724    1724    8.7595 0.0080488 ** 
##> speed:direction       1   1654    1654    8.4036 0.0092010 ** 
##> rate:direction        1   2685    2685   13.6458 0.0015406 ** 
##> grit:direction        1   5379    5379   27.3375 4.784e-05 ***
##> direction:batch       1     76      76    0.3861 0.5417191    
##> speed:rate:direction  1   7516    7516   38.1937 6.139e-06 ***
##> Residuals            19   3739     197                        
##> ---
##> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

## Add three-term interaction to data frame.
srd = s*r*d
df = data.frame(df,srd)

## Remove the direction:batch interaction since it's no longer
## significant.
newredmod = lm(formula = newstrength ~ s + r + sr +
            g + sg + d + ds + rd + srd + gd + b, data=df)
summary.lm(newredmod)

##> Call:
##> lm(formula = newstrength ~ s + r + sr + g + sg + d + ds + rd + 
##>     srd + gd + b, data = df)
##> 
##> Residuals:
##>     Min      1Q  Median      3Q     Max 
##> -29.468  -3.717  -1.389   6.560  20.294 
##> 
##> Coefficients:
##>             Estimate Std. Error t value Pr(>|t|)    
##> (Intercept) 1917.115      2.441 785.252  < 2e-16 ***
##> s              5.777      2.441   2.366 0.028183 *  
##> r             11.691      2.441   4.789 0.000112 ***
##> sr            14.467      2.441   5.926 8.53e-06 ***
##> g            -21.649      2.441  -8.867 2.29e-08 ***
##> sg            -7.339      2.441  -3.006 0.006979 ** 
##> d            -99.272      2.441 -40.662  < 2e-16 ***
##> ds             7.189      2.441   2.944 0.008016 ** 
##> rd             9.160      2.441   3.752 0.001255 ** 
##> srd           15.325      2.441   6.277 3.96e-06 ***
##> gd           -12.965      2.441  -5.311 3.38e-05 ***
##> b            -31.871      2.441 -13.055 3.03e-11 ***
##> ---
##> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

##> Residual standard error: 13.81 on 20 degrees of freedom
##> Multiple R-squared: 0.9904,     Adjusted R-squared: 0.9851 
##> F-statistic: 187.8 on 11 and 20 DF,  p-value: < 2.2e-16 


## Plot residuals versus predicted, transformed response.
par(mfrow=c(1,1),bg=rgb(1,1,0.8))
plot(predict(newredmod),newredmod$residuals,ylab="Residual",
     xlab="Predicted Transformed Strength")
abline(h=0)


## Generate four plots of residuals based on transformed response.
par(mfrow=c(2,2),bg=rgb(1,1,0.8))
qqnorm(newredmod$residuals)
qqline(newredmod$residuals, col = 2)
abline(h=0)
boxplot(newredmod$residuals, horizontal=TRUE, main="Box Plot", 
        xlab="Residual")
hist(newredmod$residuals, main="Histogram", xlab="Residual")
plot(order, newredmod$residuals, xlab="Actual Run Order", 
     ylab="Residual", main="Run Order Plot")
par(mfrow=c(1,1))


## Rearrange data so that factors and levels are in single columns.
n = length(df$strength[df$batch==1])
k = qt(.975,n-1)

group = rep(1:5,each=length(strength))
nstr = rep(newstrength,5)
level = c(m[,1],m[,2],m[,3],m[,4],m[,5])
dflong = data.frame(group,level,nstr)

gmn = aggregate(x=dflong$nstr,by=list(dflong$group,dflong$level),FUN="mean")
gsd = aggregate(x=dflong$nstr,by=list(dflong$group,dflong$level),FUN="sd")
cibar = k*gsd[3]/sqrt(n)
cgroup = rep(c("Speed","Rate","Grit","Direction","Batch"),2)

dfp = data.frame(cgroup,gmn,gsd[3],cibar)
names(dfp)=c("cgroup","group","level","tmean","std","cibar")


## Attach lattice library and generate main effects plot.
library(lattice)
par(mfrow=c(1,1))
xyplot(tmean~level|cgroup,data=dfp,layout=c(5,1),xlim=c(-2,2),
       ylab="Transformed Strength",xlab="Factor Levels", type="b",
panel = function(x, y, ...){
panel.xyplot(x, y, ...)
panel.abline(h = mean(newstrength), lty = 2, col = 2)})


## Generate two types of 2-way interaction plots.

## 2-way interaction plots showing overall effects.
group2 = rep(1:10,each=length(strength))
nstr2 = rep(newstrength,10)
level2 = c(db,gd,gb,rg,rd,rb,sr,sg,ds,sb)
df2way = data.frame(group2,level2,nstr2)

gmn2 = aggregate(x=df2way$nstr2,by=list(df2way$group2,df2way$level2),FUN="mean")
gsd2 = aggregate(x=df2way$nstr2,by=list(df2way$group2,df2way$level2),FUN="sd")

cgr2 = rep(c("d*b","g*d","g*b","r*g","r*d","r*b","s*r","s*g","s*d","s*b"),2)
dfp2 = data.frame(cgr2,gmn2,gsd2[3])
names(dfp2)=c("cgroup","group","level","tmean","std")

# Generate plot.
sp = c(T,T,T,F, T,T,F,F, T,F,F,F, F,F,F,F)
strip.bg_custom = trellis.par.get("strip.background")
strip.bg_custom$col =c("#cce6ff","#ffe5cc","#ccffcc","#ccffff","#ffccff",
                       "#ffcccc","#ffffcc")
strip.sh_custom = strip.bg_custom
trellis.par.set("strip.background", strip.bg_custom)
trellis.par.set("strip.shingle", strip.sh_custom)
xyplot(tmean~level | group, data=dfp2, type="b", xlim=c(-2,2),
       layout=c(4,4), skip=sp, col=c(4), ylim=c(1900,1935),
       strip = function(..., style,factor.levels,strip.levels,strip.names)
               strip.default(..., style = 1,factor.levels=cgr2,
                             strip.levels=c(F,T),strip.names=c(T,F)),
       xlab="Factor Level", ylab="Transformed Strength",
panel = function(x, y, ...){
panel.xyplot(x, y, ...)
panel.abline(h = mean(newstrength), lty = 2, col = 2)})


## 2-way interaction plot showing means for all combinations of
## levels for the two factors.

## Compute means for plotting.
dfi = data.frame(s,r,g,d,b,newstrength)

mnsr = aggregate(x=dfi$newstrength,by=list(dfi$s,dfi$r),FUN="mean")
mnsg = aggregate(x=dfi$newstrength,by=list(dfi$s,dfi$g),FUN="mean")
mnsd = aggregate(x=dfi$newstrength,by=list(dfi$s,dfi$d),FUN="mean")
mnsb = aggregate(x=dfi$newstrength,by=list(dfi$s,dfi$b),FUN="mean")

mnrs = aggregate(x=dfi$newstrength,by=list(dfi$r,dfi$s),FUN="mean")
mnrg = aggregate(x=dfi$newstrength,by=list(dfi$r,dfi$g),FUN="mean")
mnrd = aggregate(x=dfi$newstrength,by=list(dfi$r,dfi$d),FUN="mean")
mnrb = aggregate(x=dfi$newstrength,by=list(dfi$r,dfi$b),FUN="mean")

mngs = aggregate(x=dfi$newstrength,by=list(dfi$g,dfi$s),FUN="mean")
mngr = aggregate(x=dfi$newstrength,by=list(dfi$g,dfi$r),FUN="mean")
mngd = aggregate(x=dfi$newstrength,by=list(dfi$g,dfi$d),FUN="mean")
mngb = aggregate(x=dfi$newstrength,by=list(dfi$g,dfi$b),FUN="mean")

mnds = aggregate(x=dfi$newstrength,by=list(dfi$d,dfi$s),FUN="mean")
mndr = aggregate(x=dfi$newstrength,by=list(dfi$d,dfi$r),FUN="mean")
mndg = aggregate(x=dfi$newstrength,by=list(dfi$d,dfi$g),FUN="mean")
mndb = aggregate(x=dfi$newstrength,by=list(dfi$d,dfi$b),FUN="mean")

mnbs = aggregate(x=dfi$newstrength,by=list(dfi$b,dfi$s),FUN="mean")
mnbr = aggregate(x=dfi$newstrength,by=list(dfi$b,dfi$r),FUN="mean")
mnbg = aggregate(x=dfi$newstrength,by=list(dfi$b,dfi$g),FUN="mean")
mnbd = aggregate(x=dfi$newstrength,by=list(dfi$b,dfi$d),FUN="mean")

xcol = rbind(mnbs,mnbr,mnbg,mnbd, mnds,mndr,mndg,mndb,
       mngs,mngr,mngd,mngb, mnrs,mnrg,mnrd,mnrb, mnsr,mnsg,mnsd,mnsb)
gi = rep(c("b*s","b*r","b*g","b*d",
           "d*s","d*r","d*g","d*b",
           "g*s","g*r","g*d","g*b",
           "r*s","r*g","r*d","r*b",
           "s*r","s*g","s*d","s*b"),each=4)
dff = data.frame(gi,xcol)

## Generate the lattice plot.
sp = c(T,F,F,F,F, F,T,F,F,F, F,F,T,F,F, F,F,F,T,F, F,F,F,F,T)
xyplot(x ~ Group.1 | gi, data=dff, group=Group.2,
       layout=c(5,5), skip=sp, xlim=c(-2,2),
       ylab = "Transformed Strength", xlab = "Factor Level",
       main = "Blue: low level, Pink: high level",
       type=c("p","l"), pch=20, cex=1, col=c(4,6),
       panel=function(x,y,...){panel.superpose(x,y,...)})
trellis.focus("toplevel") ## has coordinate system [0,1] x [0,1]
panel.text(0.200, 0.200, "Batch",     cex=1)
panel.text(0.365, 0.365, "Direction", cex=1)
panel.text(0.515, 0.515, "Grit",      cex=1)
panel.text(0.675, 0.675, "Rate",      cex=1)
panel.text(0.825, 0.825, "Speed",     cex=1)
trellis.unfocus()



