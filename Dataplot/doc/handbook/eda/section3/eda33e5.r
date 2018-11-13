R commands and output:

##  Import ascii data file and generate histogram.
y <- scan("zarr14.dat",skip=25)

hist(y)
##  Attach mclust library.
library(mclust)

##  Fit bimodal mixture model.
yBIC = mclustBIC(y, modelNames="V")
yModel = mclustModel(y, yBIC)

##  Print model parameters.
yModel$parameters$mean

>        1        2
> 9.182039 9.261662 

yModel$parameters$variance$sigmasq

> [1] 0.0004006869 0.0005188599
