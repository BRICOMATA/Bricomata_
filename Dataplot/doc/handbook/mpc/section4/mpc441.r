R commands and output:

## Read the data and save relevant variables.
m <- read.table("mpc411.dat", header=FALSE, skip=2)
run = m[,1]
day = m[,5]
stddev = m[,9]
df = m[,10]

sumofsquare = df*stddev*stddev
sumofsumofsquare = sum(sumofsquare)
sumdf = sum(df)
s1 = (sumofsumofsquare/sumdf)^0.5

print(cbind(run, day, df, stddev, sumofsquare))

>	      run day df stddev sumofsquare
>	 [1,]   1  15  5 0.1024  0.05242880
>	 [2,]   1  17  5 0.0943  0.04446245
>	 [3,]   1  18  5 0.0622  0.01934420
>	 [4,]   1  22  5 0.0702  0.02464020
>	 [5,]   1  23  5 0.0627  0.01965645
>	 [6,]   1  24  5 0.0622  0.01934420
>	 [7,]   2  12  5 0.0996  0.04960080
>	 [8,]   2  18  5 0.0533  0.01420445
>	 [9,]   2  19  5 0.0364  0.00662480
>	[10,]   2  19  5 0.0768  0.02949120
>	[11,]   2  20  5 0.1042  0.05428820
>	[12,]   2  21  5 0.0868  0.03767120

print(paste("total degrees of freedom for s1:", sumdf))

>	[1] "total degrees of freedom for s1: 60"

print(paste("total sum of squares for s1:", sumofsumofsquare))

>	[1] "total sum of squares for s1: 0.37175695"

print(paste("pooled value for the repeatability standard deviation:", 
      format(s1,digits=3)))

>	[1] "pooled value for the repeatability standard deviation: 0.0787"
