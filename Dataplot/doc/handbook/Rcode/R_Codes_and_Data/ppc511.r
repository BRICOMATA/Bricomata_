R commands and output:

## Read data and save relevant variables.
m = matrix(scan("furnace.dat",skip=25),ncol=4,byrow=T)
thickness = m[,4]

## Generate summary statistics for thickness.
mnt = mean(thickness)
sdt = sd(thickness)
n = length(thickness)
stderr = sdt/sqrt(n)

## Generate plots of the data.
library(Hmisc)
par(mfrow = c(2, 2))
qqnorm(thickness,main="")
boxplot(thickness,ylab="Film Thickness (ang.)")
x = thickness
hist(x,main="", xlab="Film Thickness (ang.)", freq=FALSE, ylim=c(0,0.02),
     breaks=15)
curve(dnorm(x, mean = mnt, sd=sdt), col = 2, lwd = 2, add = TRUE)

## Compute 95 % confidence interval for the mean.
df = n-1
alpha = 0.05
Tvalue = qt(1-alpha/2,df=df)
Lower = mnt - Tvalue*stderr
Upper = mnt + Tvalue*stderr
ci = c(round(mnt,5), round(Lower,5), round(Upper,5))

## Compute 95 % confidence interval for the variance.
chilower = qchisq(alpha/2, df)
chiupper = qchisq(alpha/2, df, lower.tail = FALSE)
v = var(thickness)
vci = c(round(sdt,5),round(sqrt(df * v/chiupper),5), 
                     round(sqrt(df * v/chilower),5))
 
## Print confidence intervals.
q = data.frame(rbind(ci,vci))
names(q)= c("Estimate", "Lower CI Bound", "Upper CI Bound")
row.names(q) = c("Mean","Stan. Dev.")
q

>            Estimate Lower CI Bound Upper CI Bound
> Mean       563.03571      559.16916      566.90227
> Stan. Dev.  25.38468       22.92967       28.43306

## Compute and print thickness quantiles.
p = c(0,0.5,2.5,10,25,50,75,90,95,97.5,99.5,100)/100
Quantiles = round(quantile(thickness,probs=p,type=6),2)
as.data.frame(Quantiles)

>       Quantiles
> 0%       487.00
> 0.5%     487.00
> 2.5%     514.23
> 10%      532.90
> 25%      546.25
> 50%      562.50
> 75%      582.75
> 90%      595.00
> 95%      608.10
> 97.5%    615.10
> 99.5%    634.00
> 100%     634.00

## Define target, USL, and LSL.
USL = 660
LSL = 460
Target = 560
ult = c(LSL, USL, Target)

## Compute Cp and a 95 % confidence interval.
Cpi = (USL - LSL)/(6*sdt)
Cp_cilo = Cpi*sqrt(qchisq(alpha/2, df)/df)
Cp_ciup = Cpi*sqrt(qchisq(1-alpha/2, df)/df)
Cp = round(c(Cpi, Cp_cilo, Cp_ciup),3)

## Compute CpL and a 95 % confidence interval.
CpLi = (mnt - LSL)/(3*sdt)
CpL_se = sqrt(1/(9*n) + (CpLi**2)/(2*df))
CpL_cilo = CpLi - qnorm(1-alpha/2)*CpL_se 
CpL_ciup = CpLi + qnorm(1-alpha/2)*CpL_se
CpL = round(c(CpLi, CpL_cilo, CpL_ciup),3)

## Compute CpU and a 95 % confidence interval.
CpUi = (USL - mnt)/(3*sdt)
CpU_se = sqrt(1/(9*n) + (CpUi**2)/(2*df))
CpU_cilo = CpUi - qnorm(1-alpha/2)*CpU_se 
CpU_ciup = CpUi + qnorm(1-alpha/2)*CpU_se
CpU = round(c(CpUi, CpU_cilo, CpU_ciup),3)

## Compute Cpk and a 95 % confidence interval.
Cpki = min(CpL,CpU)
Cpk_se = sqrt(1/(9*n) + (Cpki**2)/(2*df))
Cpk_cilo = Cpki - qnorm(1-alpha/2)*Cpk_se 
Cpk_ciup = Cpki + qnorm(1-alpha/2)*Cpk_se
Cpk = round(c(Cpki, Cpk_cilo, Cpk_ciup),3)

## Compute Cpm and a 95 % confidence interval.
Cpmi = (USL - LSL)/(6*sqrt(sdt**2 + (mnt - Target)**2))
Cpm_cilo = Cpmi * sqrt(qchisq(alpha/2, df)/df)
Cpm_ciup = Cpmi * sqrt(qchisq(1-alpha/2, df)/df)
Cpm = round(c(Cpmi, Cpm_cilo, Cpm_ciup),3)

## Save and print the capability indices.
Index = data.frame(rbind(Cp, CpL, CpU, Cpk, Cpm))
names(Index)= c("Estimate", "Lower CI", "Upper CI")
Index

>     Estimate Lower CI Upper CI
> Cp     1.313    1.172    1.454
> CpL    1.353    1.199    1.507
> CpU    1.273    1.128    1.419
> Cpk    1.128    1.128    1.419
> Cpm    1.304    1.164    1.443

## Compute actual percent defective.
defect_act_lt = 100*length(subset(thickness,thickness < LSL))/n
defect_act_gt = 100*length(subset(thickness,thickness > USL))/n
defect_act = 100*length(subset(thickness, 
                        thickness < LSL | thickness > USL))/n

## Compute theoretical percent defective assuming a normal distribution.
defect_theo_lt = 100*pnorm((LSL - mnt)/sdt)
defect_theo_gt = 100*pnorm((USL - mnt)/sdt,lower.tail=FALSE)
defect_theo = defect_theo_lt + defect_theo_gt

## Print percent defective.
Outside_LSL = round(cbind(LSL,defect_act_lt,defect_theo_lt),5)
Outside_USL = round(cbind(USL,defect_act_gt,defect_theo_gt),5)
Outside_Target = round(cbind(Target,defect_act,defect_theo),5)

results = data.frame(rbind(Outside_LSL, Outside_USL, Outside_Target))
names(results)= c("Value","% Actual", "% Theoretical")
row.names(results) = c("Outside LSL","Outside USL","Outside Target")
results

>                Value % Actual % Theoretical
> Outside LSL      460        0       0.00246
> Outside USL      660        0       0.00668
> Outside Target   560        0       0.00914

##########
## 3.5.1.3

## Define variables.
run = m[,1]
zone = m[,2]
wafer = m[,3]
thickness = m[,4]

## Generate box plot for each run.
par(mfrow=c(1,1))
df = data.frame(thickness,run,zone,wafer)
boxplot(thickness~run, data=df, ylab="Film Thickness (ang.)", xlab="Run",
        main="Box Plot by Run")
abline(h=mean(thickness))

## Generate box plot for each furnace location (zone).
df = data.frame(thickness,run,zone,wafer)
boxplot(thickness~zone, data=df, ylab="Film Thickness (ang.)",
        xlab="Furnace Location",
        main="Box Plot by Furnace Location")
abline(h=mean(thickness))

## Generate box plot for each wafer.
df = data.frame(thickness,run,zone,wafer)
boxplot(thickness~wafer, data=df, ylab="Film Thickness (ang.)",
        xlab="Wafer", main="Box Plot by Wafer")
abline(h=mean(thickness))

## Save variables as factors.
fact = as.factor((run*100 + zone)/100)
fwafer = factor(wafer)
df = data.frame(thickness,fact,fwafer)

## Compute the batch means for each laboratory.
avg = aggregate(x=df$thickness, by=list(df$fact,df$fwafer), FUN="mean")

## Generate the block plot.
## Specify locations of the bars on the x axis.
xpos = c(1:84)
boxplot(avg$x ~ avg$Group.1, medlty="blank", xlim=c(1,84), 
        boxwex=.05, varwidth=FALSE,
        ylab="Film Thickness (ang.)",
        xlab="Furnace Location Within Run",
        main="Block Plot by Furnace Location",
        at=xpos,xaxt="n")
axis(side=1,at=seq(2.5,82.5,by=4),
     labels=c("1","2","3","4","5","6","7","8","9","10","11",
              "12","13","14","15","16","17","18","19","20","21"))

## Add labels for the wafer means.
f1 = avg[avg$Group.2==1,3]
f2 = avg[avg$Group.2==2,3]
for(i in (1:length(f1))) {
if(f1[i] > f2[i])
{text(xpos[i],f1[i],labels="1", pos=3, cex=.5, offset=.15)
 text(xpos[i],f2[i],labels="2", pos=1, cex=.5, offset=.15)}
else{text(xpos[i],f1[i],labels="1", pos=1, cex=.5, offset=.15)
     text(xpos[i],f2[i],labels="2", pos=3, cex=.5, offset=.15)}
}


##########
## 3.5.1.4

## Prepare data frame.
run = as.factor(m[,1])
zone = as.factor(m[,2])
df = data.frame(thickness,run,zone,wafer)

## Perform nested analysis of variance.
q = summary(aov(thickness ~ run + Error(run/zone), data=df))
q2 = unlist(q)

## Generate F tests.
F_value = q2[3]/q2[6]
p_value = pf(F_value, q2[1], q2[4], lower.tail = FALSE)
res1 = cbind(q2[1],q2[2],q2[3],F_value,p_value)
row.names(res1) = c("Run")

F_value = q2[6]/q2[11]
p_value = pf(F_value, q2[4], q2[9], lower.tail = FALSE)
res2 = cbind(q2[4],q2[5],q2[6],F_value,p_value)
row.names(res2) = c("Location(Run)")

## Print ANOVA table.
res3 = cbind(q2[9],q2[10],q2[11],NA,NA)
row.names(res3) = c("Within")
res = rbind(res1,res2,res3)
colnames(res) = c("DOF","SSE","MSE","F Ratio","Prob > F")
res

>               DOF      SSE       MSE  F Ratio     Prob > F
> Run            20 61442.29 3072.1143 5.374035 1.393903e-07
> Location(Run)  63 36014.50  571.6587 4.728639 3.850360e-11
> Within         84 10155.00  120.8929       NA           NA

## Compute variance components.
library("nlme")
fit.lme=lme(thickness ~ 1, random = ~ 1|run/zone, df, method="REML")
v = VarCorr(fit.lme)
vsub = matrix(as.numeric(v[c(2,4,5),]),ncol=2)

## Compute percent of total variation.
total = sum(vsub[,1])
percent = round(100*vsub[,1]/total,2)

## Print results
vc = data.frame(round(vsub,3),percent)
colnames(vc)= c("  Var. Comp.", "  Stan. Dev", "  % of Total") 
row.names(vc) = c("Run","Location(Run)", "Within")
vc

>                 Var. Comp.   Stan. Dev   % of Total
> Run                312.557      17.679        47.44
> Location(Run)      225.381      15.013        34.21
> Within             120.893      10.995        18.35



