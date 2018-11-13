R commands:

## Read data from file.
x <- read.table("mass.dat", header=FALSE, skip=4)
colnames(x) <- c("date_year", "std_id", "std_value","balance_id", 
                 "std_dev", "design_id")

## Compute pooled standard deviation.
sp=sqrt(mean(x$std_dev^2))

## Determine control limit.
f = sqrt(qf(.99,3,351))
sul = f*sp

## Generate control chart with reference lines.
plot(x$date_year, x$std_dev, cex.sub=0.9,
     xlab="Time, years", ylab="Standard Deviation, micrograms",
     main="Control Chart for Precision for Balance #12",
     sub="Standard deviations with 3 degrees of freedom plotted vs year")
abline(h=sp)
abline(h=sul, lty=2,col="dark green")
text(86,0.072,"Control limit = 0.067 micrograms",cex=0.9)

