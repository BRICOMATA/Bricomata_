R commands:

## Read data from file.
x = read.table("mass.dat", header=FALSE, skip=4)
colnames(x) = c("date_year", "std_id", "std_value","balance_id", 
                 "std_dev", "design_id")

## Index of the limit for historical data.
ind = which(x[,1] > 85)
ind85 = ind[1]
color = rep("black", nrow(x))
color[x[,1] <= 85] = "black"
color[x[,1] > 85] = "dark green"
	
## Generate EWMA chart.
par(bg=rgb(1,1,0.8))
plot(x[,1], x[,3], type="p", pch=4, col=color, xlim=c(75,92), 
     main=expression( paste( "EWMA control chart for mass calibrations, ", 
     lambda," = 0.2") ), xlab="Time in years", ylab="Corrections (mg)")

## Year limit for historical data.
abline(v=85, col="dark green")

## Compute the average of the historical data
target = mean(x[1:(ind85-1),3])
segments(x0=75, y0=target, x1=x[nrow(x),1], y1=target, col="dark green")
text(x[nrow(x),1], target, paste("target = ", as.character(round(target, 
     digits=3))),	pos=4, cex=0.8, col="dark green")

## Standard deviation of the historical data.
s = sd(x[1:(ind85-1),3])	
lambda = 0.2
k = 3

## Compute the upper control limit.
ucl = target + s*k*sqrt(lambda / (2-lambda))
segments(x0=85, y0=ucl, x1=x[nrow(x),1], y1=ucl, col="red")
text(x[nrow(x),1], ucl, paste("UCL = ", as.character(round(ucl, digits=3))),
	pos=4, cex=0.8, col="red")

## Compute the lower control limit.
lcl = target - s*k*sqrt(lambda / (2-lambda))
segments(x0=85, y0=lcl, x1=x[nrow(x),1], y1=lcl, col="red")
text(x[nrow(x),1], lcl, paste("LCL = ", as.character(round(lcl, digits=3))),
	pos=4, cex=0.8, col="red")

## Determine EWMA signals.
iter = 1
meani = array(target,dim=length(ind))
for (i in ind)
{
	yi = x[i,3]
	meanip1 = lambda*yi + (1 - lambda)*meani[iter]
	iter = iter+1
	meani[iter] = meanip1
}
points(x[ind,1], meani[1:iter-1], type="p", pch=20, col="black")
points(x[ind,1], meani[1:iter-1], type="l", lwd=2, col="black")

