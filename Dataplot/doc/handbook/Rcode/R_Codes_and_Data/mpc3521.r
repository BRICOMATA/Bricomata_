R commands:

## Read data from data file.
x <- read.table("mass.dat", header=FALSE, skip=4)
colnames(x) <- c("date_year", "std_id", "std_value","balance_id", 
                 "std_dev", "design_id")

## Generate control limits based on years prior to 1985.
mn = mean(x[x$date_year<85,3])
std =  sd(x[x$date_year<85,3])
lcl = mn - 3*std
ucl = mn + 3*std

## Generate control chart with reference lines.
par(bg=rgb(1,1,0.8))
plot(x$date_year, x$std_value, ylim=c(-19.6,-19.3),
     xlab="Time, years", ylab="Corrections, micrograms",
     main="Shewhart control chart for kilogram calibrations")
abline(h=mn)
abline(h=lcl,lty=2,col="dark green")
abline(h=ucl,lty=2,col="dark green")
text(80, ucl+.006, cex=0.8,
     paste("UCL = mean + 3s =", round(ucl, digits=2)," micrograms"))
text(80, lcl-.006, cex=0.8,
     paste("LCL = mean - 3s =", round(lcl, digits=2)," micrograms")) 

## Generate control limits based on years after 1985.
amn = mean(x[x$date_year>85,3])
astd =  sd(x[x$date_year>85,3])
alcl = amn - 3*astd
aucl = amn + 3*astd

## Define colors for plotting.
color <- rep("black", nrow(x))
color[x[,1] <= 85] <- "black"
color[x[,1] > 85] <- "dark green"
	
## Generate revised control chart.
par(bg=rgb(1,1,0.8))
plot(x[,1], x[,3], type="p", col=color, 
     xlim=c(75,90), ylim=c(-19.6,-19.3), 
     main="Revised control chart for kilogram calibrations", 
     xlab="Time, years", ylab="Corrections, micrograms")
segments(x0=75,y0=mn,x1=85,y1=mn)
segments(x0=85,y0=amn,x1=90,y1=amn)
segments(x0=75,y0=lcl,x1=85,y1=lcl,lty=2,col="dark green")
segments(x0=85,y0=alcl,x1=90,y1=alcl,lty=2,col="dark green")
segments(x0=75,y0=ucl,x1=85,y1=ucl,lty=2,col="dark green")
segments(x0=85,y0=aucl,x1=90,y1=aucl,lty=2,col="dark green")
text(87.5, aucl+0.006, paste("UCL = ", round(aucl,2),"micrograms"), cex=0.8)
text(87.5, alcl-0.006, paste("LCL = ", round(alcl,2),"micrograms"), cex=0.8)
