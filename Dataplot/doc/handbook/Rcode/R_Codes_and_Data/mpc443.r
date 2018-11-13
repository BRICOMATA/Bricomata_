R commands and output:

## Read data.
m = read.table("mpc411.dat", header=FALSE, skip=2)
run = m[,1]
avg = m[,8]

## Differentiate between the two runs.
n1 = which(run[] == 1)
n2 = which(run[] == 2)

## Compute averages.
meanrun1 = mean(avg[n1])
meanrun2 = mean(avg[n2])
mean = ( meanrun1 + meanrun2 ) / 2

## Compute level-3 standard deviation.
sumofsquare = (meanrun1 - mean)^2 + (meanrun2 - mean)^2
nu = 1
s3 = sqrt( sumofsquare / nu )

## Print results.
print(paste("level-3 standard deviation:", round(s3,6)))
##>[1] "level-3 standard deviation: 0.02885"

print(paste("degree of freedom:", nu))
##> [1] "degree of freedom: 1"


