R commands and output:

## Input data and save relevant variables.
m <- read.table("mpc62.dat", skip=14)
colnames(m) <- c("crystalID","stdID","month","day","hour","minute",
                 "op","humidity","probeID","temp","chkstd","stddev","df")
day = m[,4]
stddev = m[,12]
df = m[,13]

## Compute the level-1 standard deviation.
sumofsquare = df*stddev*stddev
sumofsumofsquare = sum(sumofsquare)
sumdf = sum(df)
s1 = (sumofsumofsquare/sumdf)**0.5
round(s1,5)

> [1] 0.06139

## Compute the level-2 standard deviation.
s2 = sd(m$chkstd)
round(s2,5)

> [1] 0.0268


## Compute the upper quantile of the F distribution.
f1 <- qf(0.95, 5, 125)
f1

> [1] 2.286771

## Compute the upper Control Limit
ucl1 <- s1*f1**0.5
round(ucl1,5)

> [1] 0.09283

## Generate control chart for bias and variability.
center = mean(m$chkstd)
ucl = center + 2*s2
lcl = center - 2*s2

print(paste("LCL=", round(lcl,5), " Center=",round(center,5),
      " UCL=",round(ucl,5)), quote=FALSE)

> [1] LCL= 97.01624  Center= 97.06984  UCL= 97.12344


## Generate day variable for plotting.
indday <- c(24,25,26,27,28,29,30,31,1,2,3,4,5,6,7,8,9,10,11)
dayw <- vector(mode="integer", length=length(day))
for(i in 1:length(day)){
  dayw[i] <- which(indday == day[i])}

## Compute center line.
meanstddev <- sqrt(mean(stddev*stddev))

## Compute the level 1 standard deviation.
sumofsquare = df*stddev*stddev
sumofsumofsquare = sum(sumofsquare)
sumdf = sum(df)
s1 = (sumofsumofsquare/sumdf)**0.5

## Compute the upper quantile of the F distribution.
f1 <- qf(0.95, 5, 125)

## Compute the upper Control Limit
ucl1 <- s1*f1**0.5

## Generate the control chart for precision.
plot(dayw, m$stddev, pch=1, xlab="Time in days", 
     ylab="standard deviation in ohm.cm",
     xlim=c(0,20),ylim=c(0.02,0.12))
segments(min(dayw),meanstddev, max(dayw),meanstddev)
segments(min(dayw),ucl1, max(dayw),ucl1, lty="dashed")
title("Control chart for precision \n 
     (Standard deviations with probe #2362, 5% upper control limit)")

## Generate day variable for plotting.
indday <- c(24,25,26,27,28,29,30,31,1,2,3,4,5,6,7,8,9,10,11)
dayw <- vector(mode="integer", length=length(day))
for(i in 1:length(day)){
  dayw[i] <- which(indday == day[i])}

## Compute center line.
meanchkstd <- mean(m$chkstd)

## Compute level-2 standard deviation
s2 <- sd(m$chkstd)

## Compute upper and lower control limits.
ucl2 <- meanchkstd + 2*s2
lcl2 <- meanchkstd - 2*s2

## Generate the control chart for bias and long-term variability.
plot(dayw, m$chkstd, pch=1, xlab="Time in days", 
     ylab="Measurement of check standard in ohm.cm",
     xlim=c(0,20),ylim=c(97,97.2))
segments(min(dayw),meanchkstd, max(dayw),meanchkstd)
segments(min(dayw),ucl2, max(dayw),ucl2, lty="dashed")
segments(min(dayw),lcl2, max(dayw),lcl2, lty="dashed")
title("Shewhart control chart \n 
     (Check standard 137 for probe #2362, 2-sigma control limits)")


