R commands and output:

## Read data and save relevant variables.
m = matrix(scan("machine.dat",skip=25),ncol=5,byrow=T)
machine = m[,1]
day = m[,2]
time = m[,3]
sample = m[,4]
diameter = m[,5]

## Generate box plot for each machine.
df = data.frame(diameter,machine,day,time,sample)
boxplot(diameter~machine, data=df, ylab="Diameter (inches)", xlab="Machine",
        main="Box Plot by Machine")
abline(h=mean(diameter))

## Generate box plot for each day.
boxplot(diameter~day, data=df, ylab="Diameter (inches)", xlab="Day",
        main="Box Plot by Day")
abline(h=mean(diameter))

## Generate box plot for time of day.
boxplot(diameter~time, data=df, ylab="Diameter (inches)", xlab="Time of Day",
        main="Box Plot by Time of Day",names=c("AM","PM"))
abline(h=mean(diameter))

## Generate box plot by sample number.
boxplot(diameter~sample, data=df, ylab="Diameter (inches)", 
        xlab="Sample Number", main="Box Plot by Sample")
abline(h=mean(diameter))

## Save variables as factors.
machine = as.factor(m[,1])
day = as.factor(m[,2])
time = as.factor(m[,3])
sample = as.factor(m[,4])
diameter = m[,5]
df = data.frame(diameter,machine,day,time,sample)

## Perform ANOVA using all four factors.
summary(aov(diameter ~ machine+day+time+sample,data=df))

>              Df     Sum Sq    Mean Sq F value    Pr(>F)    
> machine       2 1.1076e-04 5.5377e-05 29.3162 1.276e-11 ***
> day           2 3.7340e-06 1.8670e-06  0.9884    0.3744    
> time          1 2.3580e-06 2.3580e-06  1.2481    0.2655    
> sample        9 8.8490e-06 9.8300e-07  0.5205    0.8583    
> Residuals   165 3.1168e-04 1.8890e-06                      
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

## Analysis of variance using machine only.
q = aov(diameter ~ machine,data=df)
qq = summary(q)
qq

>              Df     Sum Sq    Mean Sq F value    Pr(>F)    
> machine       2 0.00011075 0.00005538   30.01 5.988e-12 ***
> Residuals   177 0.00032662 0.00000185                      
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

## Retrieve RMSE and residual degrees of freedom from the ANOVA table.
temp = unlist(qq)
rmse = sqrt(temp[6])
dof = temp[2]

## Compute summary statistics and 95 % confidence intervals for
## each machine.
alpha = 0.05
mns = aggregate(x=df$diameter,by=list(df$machine),FUN="mean")
n = aggregate(x=df$diameter,by=list(df$machine),FUN="length")
stderr = rmse / sqrt(n$x)
Tvalue = qt(1-alpha/2,df=dof)
lower = round(mns$x - Tvalue*stderr,5)
upper = round(mns$x + Tvalue*stderr,5)

## Print results.
s = data.frame(n$Group.1, n$x, round(mns$x,5), round(stderr,5), lower, upper)
names(s) = c("Level","n", "Mean", "Std. Err.", "Lower CI", "Upper CI")
s

>   Level  n    Mean Std. Err. Lower CI Upper CI
> 1     1 60 0.12489   0.00018  0.12454  0.12523
> 2     2 60 0.12297   0.00018  0.12262  0.12331
> 3     3 60 0.12402   0.00018  0.12368  0.12437

## Generate residuals from model with machine only.
res = diameter - predict(q)

## Generate 4-plot of residuals.
library(Hmisc)
par(mfrow = c(2, 2))
plot(res, xlab="Sequence", ylab="Residuals", main="Run Sequence Plot")
plot(res, Lag(res), xlab="Residual[i-1]", ylab="Residual[i]",
     main="Lag Plot")
hist(res, xlab="Residuals", ylab="Count", main="Histogram")
qqnorm(res, xlab="Theoretical Z-Scores", ylab="Residuals",
       main="Normal Probability Plot")

## Generate data frame with new cases.
tr = c(576, 604, 583, 657, 604, 586, 510, 546, 571)
day = as.factor(rep(1:3,3))
mach = as.factor(rep(1:3,each=3))
dfnew = data.frame(mach,day,tr)

## Print data table.
matrix(tr, nrow = 3, ncol = 3, byrow = TRUE,
       dimnames = list(c("Machine 1", "Machine 2", "Machine 3"),
                       c("Day 1", "Day 2", "Day3")) )

>           Day 1 Day 2 Day3
> Machine 1   576   604  583
> Machine 2   657   604  586
> Machine 3   510   546  571

## Generate plot.
machine = rep(1:3,each=3)
par(mfrow=c(1,1))
plot(machine, tr, ylab="Throughput", xlab="Machine",
     main="Throughput by Machine", 
     cex=1.25, xlim=c(.5,3.5), xaxp=c(1,3,2))
abline(h=mean(tr))
min = aggregate(x=dfnew$tr, by=list(dfnew$mach), FUN="min")
max = aggregate(x=dfnew$tr, by=list(dfnew$mach), FUN="max")
segments(as.numeric(min$Group.1),min$x,as.numeric(max$Group.1),max$x)

## Analysis of variance for throughput.
q = aov(tr ~ mach,data=dfnew)
qq = summary(q)
qq

>             Df Sum Sq Mean Sq F value  Pr(>F)  
> mach         2 8216.9  4108.4  4.9007 0.05475 .
> Residuals    6 5030.0   838.3                  
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

## Retrieve RMSE and residual degrees of freedom from the ANOVA table.
temp = unlist(qq)
rmse = sqrt(temp[6])
dof = temp[2]

## Compute summary statistics and 95 % confidence intervals for
## each machine.
alpha = 0.05
mns = aggregate(x=dfnew$tr,by=list(dfnew$mach),FUN="mean")
n = aggregate(x=dfnew$tr,by=list(dfnew$mach),FUN="length")
stderr = rmse / sqrt(n$x)
Tvalue = qt(1-alpha/2,df=dof)
lower = round(mns$x - Tvalue*stderr,2)
upper = round(mns$x + Tvalue*stderr,2)

## Print results.
s = data.frame(n$Group.1, n$x, round(mns$x,2), round(stderr,2), lower, upper)
names(s) = c("Level","n", "Mean", "Std. Err.", "Lower CI", "Upper CI")
s

>   Level n   Mean Std. Err. Lower CI Upper CI
> 1     1 3 587.67     16.72   546.76   628.57
> 2     2 3 615.67     16.72   574.76   656.57
> 3     3 3 542.33     16.72   501.43   583.24


