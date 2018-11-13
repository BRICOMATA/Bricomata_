R commands and output:

## Input data.
y = c(-0.25, 0.68, 0.94, 1.15, 1.20, 1.26, 1.26,
       1.34, 1.38, 1.43, 1.49, 1.49, 1.55, 1.56,
       1.58, 1.65, 1.69, 1.70, 1.76, 1.77, 1.81,
       1.91, 1.94, 1.96, 1.99, 2.06, 2.09, 2.10,
       2.14, 2.15, 2.23, 2.24, 2.26, 2.35, 2.37,
       2.40, 2.47, 2.54, 2.62, 2.64, 2.90, 2.92,
       2.92, 2.93, 3.21, 3.26, 3.30, 3.59, 3.68,
       4.30, 4.64, 5.34, 5.42, 6.01)

## Generate normal probability plot.
qqnorm(y)

## Create function to compute the test statistic.
rval = function(y){
       ares = abs(y - mean(y))/sd(y)
       df = data.frame(y, ares)
       r = max(df$ares)
       list(r, df)}

## Define values and vectors.
n = length(y)
alpha = 0.05
lam = c(1:10)
R = c(1:10)

## Compute test statistic until r=10 values have been
## removed from the sample.
for (i in 1:10){

if(i==1){
rt = rval(y)
R[i] = unlist(rt[1])
df = data.frame(rt[2])
newdf = df[df$ares!=max(df$ares),]}

else if(i!=1){
rt = rval(newdf$y)
R[i] = unlist(rt[1])
df = data.frame(rt[2])
newdf = df[df$ares!=max(df$ares),]}

## Compute critical value.
p = 1 - alpha/(2*(n-i+1))
t = qt(p,(n-i-1))
lam[i] = t*(n-i) / sqrt((n-i-1+t**2)*(n-i+1))

}
## Print results.
newdf = data.frame(c(1:10),R,lam)
names(newdf)=c("No. Outliers","Test Stat.", "Critical Val.")
newdf

##>    No. Outliers Test Stat. Critical Val.
##> 1             1   3.118906      3.158794
##> 2             2   2.942973      3.151430
##> 3             3   3.179424      3.143890
##> 4             4   2.810181      3.136165
##> 5             5   2.815580      3.128247
##> 6             6   2.848172      3.120128
##> 7             7   2.279327      3.111796
##> 8             8   2.310366      3.103243
##> 9             9   2.101581      3.094456
##> 10           10   2.067178      3.085425



######################################################################
## ================================================================ ##
######################################################################