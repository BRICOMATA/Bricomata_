R commands and output:

## Read the data.
m <- read.table("mpc411.dat", header=FALSE, skip=2)
run = m[,1]
wafer = m[,2]
probe = m[,3]
month = m[,4]
day = m[,5]
op = m[,6]
temp = m[,7]
avg = m[,8]
stddev = m[,9]
df = m[,10]

## Differentiate between the two runs.
n1 = which(run[] == 1)
n2 = which(run[] == 2)

## Compute the level-2 standard deviation.
sdrun1 = sd(avg[n1])
dofsdrun1 = length(n1) - 1
sdrun2 = sd(avg[n2])
dofsdrun2 = length(n2) - 1
sumofsquare = (dofsdrun1*sdrun1**2 + dofsdrun2*sdrun2**2)
dofs2 = length(n1) + length(n2) - 2

## Level-2 pooled standard deviation.
s2 = sqrt(sumofsquare / dofs2)

## Print results.
qsd = rbind(sdrun1,sdrun2,s2)
qdof = rbind(dofsdrun1,dofsdrun2,dofs2)
s = data.frame(qdof,qsd)
names(s) = c( "Degrees of Freedom","   Standard Deviation")
row.names(s) = c("Run 1", "Run 2", "Pooled Level 2")
s

>                Degrees of Freedom    Standard Deviation
> Run 1                           5            0.02727935
> Run 2                           5            0.02756307
> Pooled Level 2                 10            0.02742157

## Compute the between-day standard deviation.
J = 6
sumofsquare1 = df*stddev*stddev
sumofsumofsquare = sum(sumofsquare1)
sumdf = sum(df)
s1 = (sumofsumofsquare/sumdf)^0.5
vardays = s2**2 - s1**2/J

## Print results.
print(paste("between-day variance:", round(vardays,8)))

> [1] "between-day variance: -0.00028072"


