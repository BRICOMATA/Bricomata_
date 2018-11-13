R commands and output:

## Alaska pipeline ultrasonic calibration case study

## Create vector with dependent variable, field defect size
fdef = c(18,38,15,20,18,36,20,43,45,65,43,38,33,10,50,10,50,15,53,60,18,
         38,15,20,18,36,20,43,45,65,43,38,33,10,50,10,50,15,53,15,37,15,
         18,11,35,20,40,50,36,50,38,10,75,10,85,13,50,58,58,48,12,63,10,
         63,13,28,35,63,13,45,9,20,18,35,20,38,50,70,40,21,19,10,33,16,5,
         32,23,30,45,33,25,12,53,36,5,63,43,25,73,45,52,9,30,22,56,15,45)

## Create vector with independent variable, lab defect size
ldef = c(20.2,56.0,12.5,21.2,15.5,39.0,21.0,38.2,55.6,81.9,39.5,56.4,40.5,
         14.3,81.5,13.7,81.5,20.5,56.0,80.7,20.0,56.5,12.1,19.6,15.5,38.8,
         19.5,38.0,55.0,80.0,38.5,55.8,38.8,12.5,80.4,12.7,80.9,20.5,55.0,
         19.0,55.5,12.3,18.4,11.5,38.0,18.5,38.0,55.3,38.7,54.5,38.0,12.0,
         81.7,11.5,80.0,18.3,55.3,80.2,80.7,55.8,15.0,81.0,12.0,81.4,12.5,
         38.2,54.2,79.3,18.2,55.5,11.4,19.5,15.5,37.5,19.5,37.5,55.5,80.0,
         37.5,15.5,23.7,9.8,40.8,17.5,4.3,36.5,26.3,30.4,50.2,30.1,25.5,
         13.8,58.9,40.0,6.0,72.5,38.8,19.4,81.5,77.4,54.6,6.8,32.6,19.8,
         58.8,12.9,49.0)

## Create vector with batch indicator
bat = c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
        2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,
        4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
        5,6,6,6,6,6,6,6)

## Save data in a data frame and determine number of observations
Batch <- as.factor(bat)
df <- data.frame(fdef,ldef,Batch)
len <- length(Batch)

##  Plot the data
par(cex=1.25)
xax = "Lab Defect Size"
yax = "Field Defect Size"
title = "Alaska Pipeline Ultrasonic Calibration Data"
plot(ldef,fdef,xlab=xax,ylab=yax,main=title,col="blue")

## Generate conditional plot
library("lattice")
trellis.device(new = TRUE, col = FALSE)
FIG = xyplot(fdef ~ ldef | Batch, data=df,
      main = title,
      layout=c(3,2),
      col=4,
      xlab=list(xax,cex=1.1),
      ylab=list(yax,cex=1.1),
      strip=function(...)
      strip.default(...,strip.names=c(T,T)))
plot(FIG)

##  Batch analysis
x = ldef
y = fdef
xydf = data.frame(x,y,Batch)
out = by(xydf,xydf$Batch,function(x) lm(y~x,data=x))
lapply(out,summary)

> $"1"
>
> Call:
> lm(formula = y ~ x, data = x)
>
> Residuals:
>     Min      1Q  Median      3Q     Max 
> -8.7219 -4.9844 -0.4439  3.4162 11.6738 
>
> Coefficients:
>             Estimate Std. Error t value Pr(>|t|)    
> (Intercept)  7.15730    2.97737   2.404   0.0279 *  
> x            0.63269    0.06392   9.898 1.80e-08 ***
> ---
> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>
> Residual standard error: 6.526 on 17 degrees of freedom
> Multiple R-Squared: 0.8521,     Adjusted R-squared: 0.8434 
> F-statistic: 97.98 on 1 and 17 DF,  p-value: 1.798e-08 
>
>
> $"2"
>
> Call:
> lm(formula = y ~ x, data = x)
>
> Residuals:
>      Min       1Q   Median       3Q      Max 
> -9.09547 -5.49791  0.02057  2.75029 11.25706 
>
> Coefficients:
>             Estimate Std. Error t value Pr(>|t|)    
> (Intercept)  7.51458    2.81007   2.674   0.0155 *  
> x            0.63759    0.05828  10.941  2.2e-09 ***
> ---
> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>
> Residual standard error: 6.382 on 18 degrees of freedom
> Multiple R-Squared: 0.8693,     Adjusted R-squared: 0.862 
> F-statistic: 119.7 on 1 and 18 DF,  p-value: 2.200e-09 
>
>
> $"3"
>
> Call:
> lm(formula = y ~ x, data = x)
>
> Residuals:
>     Min      1Q  Median      3Q     Max 
> -11.370  -2.390   1.396   2.488  16.250 
>
> Coefficients:
>             Estimate Std. Error t value Pr(>|t|)    
> (Intercept)  2.20247    2.82865   0.779    0.446    
> x            0.83185    0.05901  14.096 3.63e-11 ***
> ---
> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>
> Residual standard error: 6.61 on 18 degrees of freedom
> Multiple R-Squared: 0.9169,     Adjusted R-squared: 0.9123 
> F-statistic: 198.7 on 1 and 18 DF,  p-value: 3.629e-11 
>
>
> $"4"
>
> Call:
> lm(formula = y ~ x, data = x)
>
> Residuals:
>    Min     1Q Median     3Q    Max 
> -9.932 -2.775 -0.374  2.889  7.930 
>
> Coefficients:
>             Estimate Std. Error t value Pr(>|t|)    
> (Intercept)  3.18655    1.88338   1.692    0.108    
> x            0.77022    0.03938  19.560 1.41e-13 ***
> ---
> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>
> Residual standard error: 4.381 on 18 degrees of freedom
> Multiple R-Squared: 0.9551,     Adjusted R-squared: 0.9526 
> F-statistic: 382.6 on 1 and 18 DF,  p-value: 1.414e-13 
>
>
> $"5"
>
> Call:
> lm(formula = y ~ x, data = x)
>
> Residuals:
>      Min       1Q   Median       3Q      Max 
> -18.5261  -2.7865   0.8096   3.4953   8.7293 
>
> Coefficients:
>             Estimate Std. Error t value Pr(>|t|)    
> (Intercept)  4.86365    2.33614   2.082   0.0511 .  
> x            0.75791    0.05724  13.241 4.83e-11 ***
> ---
> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>
> Residual standard error: 5.829 on 19 degrees of freedom
> Multiple R-Squared: 0.9022,     Adjusted R-squared: 0.8971 
> F-statistic: 175.3 on 1 and 19 DF,  p-value: 4.834e-11 
>
>
> $"6"
>
> Call:
> lm(formula = y ~ x, data = x)
>
> Residuals:
>     101     102     103     104     105     106     107 
>  0.7125 -0.2117 -1.9221  1.3451  1.0155  0.4188 -1.3581 
>
> Coefficients:
>             Estimate Std. Error t value Pr(>|t|)    
> (Intercept)  3.22600    1.01547   3.177   0.0246 *  
> x            0.88025    0.02621  33.584  4.4e-07 ***
> ---
> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>
> Residual standard error: 1.35 on 5 degrees of freedom
> Multiple R-Squared: 0.9956,     Adjusted R-squared: 0.9947 
> F-statistic:  1128 on 1 and 5 DF,  p-value: 4.401e-07 

## Save batch regression results 
outs = sapply(out,summary)
outc = sapply(out,coef)
fitse = t(outs[6,])
fitse = c(fitse[[1]],fitse[[2]],fitse[[3]],fitse[[4]],fitse[[5]],fitse[[6]])
r2 = t(outs[8,])
r2 = c(r2[[1]],r2[[2]],r2[[3]],r2[[4]],r2[[5]],r2[[6]])
b0 = t(outc[1,])
b1 = t(outc[2,])

##  Batch plots
par(mfrow=c(2,2))
id = c(1:length(b0))
xax2 = "Batch Number"
plot(id,r2,xlab=xax2,ylab="Correlation",ylim=c(.8,1),
     col="blue",pch=16,cex=1.25)
abline(h=mean(r2))
plot(id,b0[1,],xlab=xax2,ylab="Intercept",ylim=c(0,8),
     col="blue",pch=16,cex=1.25)
abline(h=mean(b0))
plot(id,b1[1,],xlab=xax2,ylab="Slope",ylim=c(.5,.9),
     col="blue",pch=16,cex=1.25)
abline(h=mean(b1))
plot(id,fitse,xlab=xax2,ylab="RESSD",ylim=c(0,7),
     col="blue",pch=16,cex=1.25)
abline(h=mean(fitse))
par(mfrow=c(1,1))

## Straight line regression analysis
out = lm(fdef~ldef)
summary(out)

> Call:
> lm(formula = fdef ~ ldef)
>
> Residuals:
>      Min       1Q   Median       3Q      Max 
> -16.5817  -3.8259   0.1283   3.7432  21.5174 
>
> Coefficients:
>             Estimate Std. Error t value Pr(>|t|)    
> (Intercept)  4.99368    1.12566   4.436 2.26e-05 ***
> ldef         0.73111    0.02455  29.778  < 2e-16 ***
> ---
> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>
> Residual standard error: 6.081 on 105 degrees of freedom
> Multiple R-Squared: 0.8941,     Adjusted R-squared: 0.8931 
> F-statistic: 886.7 on 1 and 105 DF,  p-value: < 2.2e-16 

## Residual 6-plot
par(mfrow=c(3,2))
plot(ldef,fdef,xlab="Lab Defect Size",
     ylab="Field Defect Size",main="Field Defect Size vs Lab Defect Size")
abline(reg=out)
plot(ldef,out$residuals,ylab="Residuals",xlab="Lab Defect Size",
     main="Residuals vs Lab Defect Size")
plot(out$fitted.values,out$residuals,ylab="Residuals",xlab="Predicted",
     main="Residual vs Predicted")
plot(out$residuals[2:len],out$residuals[1:len-1],ylab="Residuals",
     xlab="Lag 1 Residuals",main="Lag Plot")
hist(out$residuals,ylab="Frequency",xlab="Residuals",main="Histogram")
qqnorm(out$residuals,main="Normal Probability Plot")

## Generate plot of raw data with overlaid regression function
par(mfrow=c(1,1),cex=1.25)
plot(ldef,fdef,ylab="Field Defect Size",xlab="Lab Defect Size",
     col="blue")
abline(reg=out)
title("Alaska Pipeline Ultrasonic Calibration Data",line=2)
title("With Unweighted Line",line=1)

## Plot residuals versus lab defect size
par(mfrow=c(1,1),cex=1.25)
plot(ldef,out$residuals, xlab="Lab Defect Size", ylab="Residuals",
     main="Alaska Pipeline Data Residuals - Unweighted Fit",
     cex=1.25, col="blue")
abline(h=0)

## Transformations of response variable
lnfdef = log(fdef)
sqrtfdef = sqrt(fdef)
invfdef = 1/fdef

## Plot transformed response variable
par(mfrow=c(2,2))
xax = "Lab Defect Size"
plot(ldef,fdef,xlab=xax,ylab="Field Defect Size",col="blue")
plot(ldef,sqrtfdef,xlab=xax,ylab="Sqrt(Field Defect Size)",col="blue")
plot(ldef,lnfdef,xlab=xax,ylab="ln(Field Defect Size)",col="blue")
plot(ldef,invfdef,xlab=xax,ylab="1/Field Defect Size",col="blue")
title(main="Transformations of Response Variable",outer=TRUE,line=-2)

## Transformations of predictor variable
lnldef = log(ldef)
sqrtldef = sqrt(ldef)
invldef = 1/ldef

## Plot transformed predictor variable
par(mfrow=c(2,2))
yax = "ln(Field Defect Size)"
plot(ldef,lnfdef,xlab="Lab Defect Size", ylab=yax, col="blue")
plot(sqrtldef,lnfdef,xlab="Sqrt(Lab Defect Size)", ylab=yax, col="blue")
plot(lnldef,lnfdef,xlab="ln(Lab Defect Size)", ylab=yax, col="blue")
plot(invldef,lnfdef,xlab="1/Lab Defect Size", ylab=yax, col="blue")
title(main="Transformations of Predictor Variable",outer=TRUE,line=-2)

##  Box-Cox linearity plot
for (i in (0:100)){
    alpha = -2 + 4*i/100
    if (alpha != 0){
    tx = ((ldef**alpha) - 1)/alpha
    temp = lm(lnfdef~tx)
    temps = summary(temp)
    if(i==0) {rsq = temps$r.squared
              alp = alpha}
    else {rsq = rbind(rsq,temps$r.squared)
          alp = rbind(alp,alpha)}
    }}
rcor = sqrt(rsq)
par(mfrow=c(1,1),cex=1.25)
plot(alp,rcor,type="l",xlab="Alpha",ylab="Correlation",
     main="Box-Cox Linearity Plot ln(Field) Lab",
     ylim=c(.6,1), col="blue")

## Regression for ln-ln transformed variables
outt = lm(lnfdef~lnldef)
summary(outt)

> Call:
> lm(formula = lnfdef ~ lnldef)
>
> Residuals:
>      Min       1Q   Median       3Q      Max 
> -0.33360 -0.13982  0.03105  0.12745  0.33701 
>
> Coefficients:
>             Estimate Std. Error t value Pr(>|t|)    
> (Intercept)  0.28138    0.08093   3.477 0.000739 ***
> lnldef       0.88518    0.02302  38.457  < 2e-16 ***
> ---
> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>
> Residual standard error: 0.1683 on 105 degrees of freedom
> Multiple R-Squared: 0.9337,     Adjusted R-squared: 0.9331 
> F-statistic:  1479 on 1 and 105 DF,  p-value: < 2.2e-16 

## Plot data with overlaid regression function
par(mfrow=c(1,1),cex=1.25)
plot(lnldef,lnfdef,xlab="ln(Lab Defect Size)",ylab="ln(Field Defect Size)",
     main="Transformed Alaska Pipeline Data with Fit",col="blue")
abline(reg=outt)

## Residual 6-plot
par(mfrow=c(3,2))
plot(lnldef,lnfdef,xlab="ln(Lab Defect Size)",ylab="ln(Field Defect Size)",
     main="ln(Field Defect Size vs ln(Lab Defect Size)")
abline(reg=outt)
plot(lnfdef,outt$residuals, xlab="ln(Lab Defect Size)",ylab="Residuals",
     main="Residual vs ln(Lab Defect Size)")
plot(outt$residuals,outt$fitted.values,ylab="Residuals",xlab="Predicted",
     main="Residual vs Predicted")
plot(outt$residuals[2:len],outt$residuals[1:len-1],ylab="Residuals",
     xlab="Lag 1 Residuals",main="Lag Plot")
hist(outt$residuals,ylab="Frequency",xlab="Residuals",main="Histogram")
qqnorm(outt$residuals,main="Normal Probability Plot")

## Plot residuals versus ln(lab defect size)
par(mfrow=c(1,1),cex=1.25)
plot(lnldef,outt$residuals, xlab="ln(Lab Defect Size)",
     ylab="Residuals", main="Residuals from Fit to Transformed Data",
     cex=1.25, col="blue")
abline(h=0)

## Determine replicate groups
df = data.frame(ldef,fdef)
df = df[order(ldef),]
id = rep(1:27,each=4)
id = id[1:length(ldef)]
dfid = data.frame(id,df)

m = by(dfid$fdef,id,mean)
s2 = by(dfid$fdef,id,var)
mfdef = as.vector(m)
vfdef = as.vector(s2)
lnmfdef = log(mfdef)
lnvfdef = log(vfdef)

## Fit power function model
out2 = lm(lnvfdef~lnmfdef)
summary(out2)

> Call:
> lm(formula = lnvfdef ~ lnmfdef)
>
> Residuals:
>     Min      1Q  Median      3Q     Max 
> -2.0038 -0.5934  0.1245  0.5605  1.7062 
>
> Coefficients:
>             Estimate Std. Error t value Pr(>|t|)    
> (Intercept)  -3.1573     0.8696  -3.631  0.00127 ** 
> lnmfdef       1.7087     0.2552   6.694 5.14e-07 ***
> ---
> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>
> Residual standard error: 0.8391 on 25 degrees of freedom
> Multiple R-Squared: 0.6419,     Adjusted R-squared: 0.6276 
> F-statistic: 44.82 on 1 and 25 DF,  p-value: 5.143e-07 

## Plot power function model with power function
par(mfrow=c(1,1),cex=1.25)
plot(lnmfdef,lnvfdef,xlim=c(1,5),ylim=c(-1,6),
     ylab="ln(Replicate Variances)", xlab="ln(Replicate Means)",
     main="Fit for Estimating Weights", cex=1.25, col="blue")
abline(reg=out2)

## Plot residuals from power function model
par(mfrow=c(1,1),cex=1.25)
plot(lnmfdef,out2$residuals, main="Residuals from Weight Estimation Fit",
     ylab="Residuals", xlab="ln(Replicate Means)",ylim=c(-2,2),
     xlim=c(1,5), cex=1.25, col="blue")
abline(h=0)

## Weighted regression analysis
w = 1/(ldef**1.5)
outw = lm(fdef~ldef,weight=w)
summary(outw)
wresid = weighted.residuals(outw)

> Call:
> lm(formula = fdef ~ ldef, weights = w)
>
> Residuals:
>      Min       1Q   Median       3Q      Max 
> -0.75742 -0.30420  0.07279  0.25865  0.78715 
>
> Coefficients:
>             Estimate Std. Error t value Pr(>|t|)    
> (Intercept)  2.35234    0.54312   4.331  3.4e-05 ***
> ldef         0.80636    0.02265  35.595  < 2e-16 ***
> ---
> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>
> Residual standard error: 0.3646 on 105 degrees of freedom
> Multiple R-Squared: 0.9235,     Adjusted R-squared: 0.9227 
> F-statistic:  1267 on 1 and 105 DF,  p-value: < 2.2e-16 

## Plot data with overlaid weighted regression function
par(mfrow=c(1,1),cex=1.25)
plot(ldef,fdef,ylab="Field Defect Size", xlab="Lab Defect Size",
     col="blue")
abline(reg=outw)
title("Alaska Pipeline Data with Weighted Fit",line=2)
title("Weights=1/(Lab Defect Size)**1.5",line=1)

## Residual 6-plot
par(mfrow=c(3,2))
plot(ldef,fdef,xlab="Lab Defect Size",
     ylab="Field Defect Size",main="Field Defect Size vs Lab Defect Size")
abline(reg=outw)
plot(ldef,wresid,ylab="Residuals",xlab="Lab Defect Size",
     main="Residuals vs Lab Defect Size")
plot(outw$fitted.values,wresid,ylab="Residuals",xlab="Predicted",
     main="Residual vs Predicted")
plot(wresid[2:len],wresid[1:len-1],ylab="Residuals",
     xlab="Lag 1 Residuals",main="Lag Plot")
hist(wresid,ylab="Frequency",xlab="Residuals",main="Histogram")
qqnorm(wresid,main="Normal Probability Plot")

## Plot weighted residuals versus lab defect size
par(mfrow=c(1,1),cex=1.25)
plot(ldef,wresid,ylab="Residuals",xlab="Lab Defect Size",
     main="Residuals from Weighted Fit")
abline(h=0)

##  Generate plot to compare three fits
xval = seq(min(ldef),max(ldef))
yu = predict.lm(out,data.frame(ldef=xval))
yt = exp(outt$coef[1]+outt$coef[2]*log(xval))
yw = predict.lm(outw,data.frame(ldef=xval))

par(mfrow=c(1,1),cex=1.25)
plot(ldef,fdef,ylab="Field Defect Size", xlab="Lab Defect Size",
     xlim=c(0,90),ylim=c(0,90), cex=.85)
lines(x=xval,y=yu,lty=1, col="red")
lines(x=xval,y=yt,lty=2, col="black")
lines(x=xval,y=yw,lty=3, col="blue")
legend(85,legend=c("Unweighted Fit","Transformed Fit","Weighted Fit"),
       lty=c(1,2,3), col=c("red","black","blue"))
title("Data with Unweighted Line, WLS Fit,",line=2)
title("and Fit Using Transformed Variables",line=1)

