R commands:

## Read the data.
m = read.table(linewid.dat, header=FALSE, skip=2)
day = m[,1]
position = m[,2]
x = m[,3]
y = m[,4]

## Define the initial calibration experiment.
intercept = 0.2357	## intercept
slope = 0.9870		## slope
sd = 0.06203		## residual standard deviation

df = 38		      ## degrees of freedom
alpha = 0.05	      ## significance level
m = 3		            ## linear calibration line at 3 points

## Percentile for t* critical value.
zeta = 0.5*(1 - exp(log(1 - alpha)/m))	

## Find the upper quantile of Student distribution.
tstar = qt(p=zeta, df=df, lower.tail=FALSE)

## Control values of the calibration.
w = ((y - intercept)/slope) - x
center = 0

## Generate the control chart.
par(bg=rgb(1,1,0.8), oma=c(4, 0, 0, 0))
plot(day, w, type="p", pch=8, xlim=c(0,10), ylim=c(-0.3,0.4),
	main="Control chart for optical imaging system",
	xlab="Time in days", ylab=expression(paste("control values ( ",mu,"m)")),
	xaxs="i", yaxs="i")
axis(1,1:10)
segments(x0=1, y0=center, x1=9.75, y1=center)

## Compute upper and lower control limits.
lcl = center + sd*tstar/slope
ucl = center - sd*tstar/slope
	
## Add control limits to plot.
segments(x0=1, y0=ucl, x1=6, y1=ucl, col=grey(0.7))
segments(x0=6, y0=ucl, x1=9.75, y1=ucl, lty="dashed")
segments(x0=1, y0=lcl, x1=6, y1=lcl, col=grey(0.7))
segments(x0=6, y0=lcl, x1=9.75, y1=lcl, lty="dashed")

## Add subtitle and text to plot.
title(outer=TRUE, line=1,sub= "Linewidths corrected for linear calibration
control values at lower, mid, and upper range of calibration interval")
text(8,0,srt=45,col="gray","future control values")


