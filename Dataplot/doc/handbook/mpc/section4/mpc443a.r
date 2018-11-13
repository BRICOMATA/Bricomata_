R commands and output:

## Read data.
data = "s:/sed/jsplett/r_Handbook/data/mpc61.dat"
m = read.table(data, header=FALSE)

## Save relevant data for probe #2362 in a data frame.
m = m[m[,3]==2362,]
frun = as.factor(m[,1])
fwafer = as.factor(m[,2])
avg = m[,8]
df = data.frame(frun,fwafer,avg)

## Compute means for each run and wafer combination.
mns = aggregate(df$avg, by = list(df$frun, df$fwafer), FUN = "mean")

## Compute meanas for each wafer.
mnw = aggregate(df$avg, by = list(df$fwafer), FUN = "mean")

## Compute s3 for each wafer
ss = array(0, dim=c(length(mnw[,1]))) 
for( i in 1:length(mnw[,1]))
{
id = mnw$Group.1[i]
ss[i] = sum((mns[mns$Group.2==id,3] - mnw[mnw$Group.1==id,2])^2)
}

## Print results.
dof = rep(1,length(mnw[,1]))
Statistics = cbind(unique(m[,2]),round(sqrt(ss),4),dof,round(ss,7))
colnames(Statistics)= c("Wafer", "s3", "v", "v*s3*s3")
data.frame(Statistics)

>   Wafer     s3 v      s3.v
> 1   138 0.0222 1 0.0004946
> 2   139 0.0027 1 0.0000073
> 3   140 0.0288 1 0.0008323
> 4   141 0.0133 1 0.0001764
> 5   142 0.0205 1 0.0004191 

print(paste("SS =",round(sum(ss),7)),quote=FALSE)

> [1] SS = 0.0019297

print(paste("Pooled Value, s3 =", round(sqrt(sum(ss)/length(ss)),4)),
      quote=FALSE)

> [1] Pooled Value, s3 = 0.0196

