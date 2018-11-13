R commands:

## Read data.
fname = co2.dat
m = matrix(scan(fname,skip=2),ncol=4,byrow=T)

## Perform linear fit to detrend the data.
fit = lm(m[,1] ~ m[,2])

## Save residuals from fit as a time series object.
q = ts(fit$residuals,start=c(1974,5),frequency=12)

## Generate the seasonal subseries plot.
par(mfrow=c(1,1))
monthplot(q,phase=cycle(q), base=mean, ylab="CO2 Concentrations",
         main="Seasonal Subseries Plot of CO2 Concentrations",
         xlab="Month",
         labels=c("Jan","Feb","Mar","Apr","May","Jun",
                  "Jul","Aug","Sep","Oct","Nov","Dec"))

