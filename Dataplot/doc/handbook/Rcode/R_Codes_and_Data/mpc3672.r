R commands and output:

## Read data and define variables.
m = read.table("linewid.dat", header=FALSE, skip=2)
colnames(m) = c("day", "pos", "x", "y") 

## Specify regression coefficients from calibration experiment.
b0 = 0.2357
b1 = 0.9870

## Compute the calibration standard deviation.
w = ((m$y - b0)/b1) - m$x 
sdcal = sd(w)

## The calibration standard deviation is:
sdcal

> [1] 0.1193572
