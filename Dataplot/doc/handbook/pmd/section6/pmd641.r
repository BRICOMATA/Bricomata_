R commands and output:

## Thermal expansion of copper case study

## Create vector with dependent variable, coefficient of thermal expansion
tec = c(0.591,1.547,2.902,2.894,4.703,6.307,7.030,7.898,9.470,9.484,10.072,
      10.163,11.615,12.005,12.478,12.982,12.970,13.926,14.452,14.404,
      15.190,15.550,15.528,15.499,16.131,16.438,16.387,16.549,16.872,
      16.830,16.926,16.907,16.966,17.060,17.122,17.311,17.355,17.668,
      17.767,17.803,17.765,17.768,17.736,17.858,17.877,17.912,18.046,
      18.085,18.291,18.357,18.426,18.584,18.610,18.870,18.795,19.111,
      0.367,0.796,0.892,1.903,2.150,3.697,5.870,6.421,7.422,9.944,11.023,
      11.870,12.786,14.067,13.974,14.462,14.464,15.381,15.483,15.590,
      16.075,16.347,16.181,16.915,17.003,16.978,17.756,17.808,17.868,
      18.481,18.486,19.090,16.062,16.337,16.345,16.388,17.159,17.116,
      17.164,17.123,17.979,17.974,18.007,17.993,18.523,18.669,18.617,
      19.371,19.330,0.080,0.248,1.089,1.418,2.278,3.624,4.574,5.556,
      7.267,7.695,9.136,9.959,9.957,11.600,13.138,13.564,13.871,13.994,
      14.947,15.473,15.379,15.455,15.908,16.114,17.071,17.135,17.282,
      17.368,17.483,17.764,18.185,18.271,18.236,18.237,18.523,18.627,
      18.665,19.086,0.214,0.943,1.429,2.241,2.951,3.782,4.757,5.602,
      7.169,8.920,10.055,12.035,12.861,13.436,14.167,14.755,15.168,
      15.651,15.746,16.216,16.445,16.965,17.121,17.206,17.250,17.339,
      17.793,18.123,18.490,18.566,18.645,18.706,18.924,19.100,0.375,
      0.471,1.504,2.204,2.813,4.765,9.835,10.040,11.946,12.596,13.303,
      13.922,14.440,14.951,15.627,15.639,15.814,16.315,16.334,16.430,
      16.423,17.024,17.009,17.165,17.134,17.349,17.576,17.848,18.090,
      18.276,18.404,18.519,19.133,19.074,19.239,19.280,19.101,19.398,
      19.252,19.890,20.007,19.929,19.268,19.324,20.049,20.107,20.062,
      20.065,19.286,19.972,20.088,20.743,20.830,20.935,21.035,20.930,
      21.074,21.085,20.935)

## Create vector with independent variable, temperature (K)
temp = c(24.41,34.82,44.09,45.07,54.98,65.51,70.53,75.70,89.57,91.14,96.40,
      97.19,114.26,120.25,127.08,133.55,133.61,158.67,172.74,171.31,
      202.14,220.55,221.05,221.39,250.99,268.99,271.80,271.97,321.31,
      321.69,330.14,333.03,333.47,340.77,345.65,373.11,373.79,411.82,
      419.51,421.59,422.02,422.47,422.61,441.75,447.41,448.70,472.89,
      476.69,522.47,522.62,524.43,546.75,549.53,575.29,576.00,625.55,
      20.15,28.78,29.57,37.41,39.12,50.24,61.38,66.25,73.42,95.52,
      107.32,122.04,134.03,163.19,163.48,175.70,179.86,211.27,217.78,
      219.14,262.52,268.01,268.62,336.25,337.23,339.33,427.38,428.58,
      432.68,528.99,531.08,628.34,253.24,273.13,273.66,282.10,346.62,
      347.19,348.78,351.18,450.10,450.35,451.92,455.56,552.22,553.56,
      555.74,652.59,656.20,14.13,20.41,31.30,33.84,39.70,48.83,54.50,
      60.41,72.77,75.25,86.84,94.88,96.40,117.37,139.08,147.73,158.63,
      161.84,192.11,206.76,209.07,213.32,226.44,237.12,330.90,358.72,
      370.77,372.72,396.24,416.59,484.02,495.47,514.78,515.65,519.47,
      544.47,560.11,620.77,18.97,28.93,33.91,40.03,44.66,49.87,55.16,
      60.90,72.08,85.15,97.06,119.63,133.27,143.84,161.91,180.67,
      198.44,226.86,229.65,258.27,273.77,339.15,350.13,362.75,371.03,
      393.32,448.53,473.78,511.12,524.70,548.75,551.64,574.02,623.86,
      21.46,24.33,33.43,39.22,44.18,55.02,94.33,96.44,118.82,128.48,
      141.94,156.92,171.65,190.00,223.26,223.88,231.50,265.05,269.44,
      271.78,273.46,334.61,339.79,349.52,358.18,377.98,394.77,429.66,
      468.22,487.27,519.54,523.03,612.99,638.59,641.36,622.05,631.50,
      663.97,646.90,748.29,749.21,750.14,647.04,646.89,746.90,748.43,
      747.35,749.27,647.61,747.78,750.51,851.37,845.97,847.54,849.93,
      851.61,849.75,850.98,848.23)

## Determine number of observations
len = length(tec)

## Save labels for plots
xax = "Temperature (K)"
yax = "Coefficient of Thermal Expansion"
ttl = "Thermal Expansion of Copper Data"
ttl2 = "Q/Q Rational Function Model"

## Plot the data
par(mfrow=c(1,1),cex=1.25)
plot(temp,tec,xlab=xax,ylab=yax,main=ttl,col="blue")

## Starting values for Q/Q model
x = c(10,50,120,200,800)
y = c(0,5,12,15,20)
x2 = x*x
xy = -x*y
x2y = -(x*x*y)
sout = lm(y~x+x2+xy+x2y)
stc = sout$coef
stc

>   (Intercept)             x            x2            xy           x2y 
> -3.0054502985  0.3688294835 -0.0068284454 -0.0112341033 -0.0003061251 

## Fit Q/Q model
out = nls(tec ~ (a0 + a1*temp + a2*temp**2)/(1 + b1*temp + b2*temp**2),
    start=list(a0=stc[1],a1=stc[2],a2=stc[3],b1=stc[4],b2=stc[5]))
outs = summary(out)
outs

> Formula: tec ~ (a0 + a1 * temp + a2 * temp^2)/(1 + b1 * temp + b2 * temp^2)
>
> Parameters:
>      Estimate Std. Error t value Pr(>|t|)    
> a0 -8.028e+00  3.988e-01  -20.13   <2e-16 ***
> a1  5.083e-01  1.930e-02   26.33   <2e-16 ***
> a2 -7.307e-03  2.463e-04  -29.67   <2e-16 ***
> b1 -7.040e-03  5.235e-04  -13.45   <2e-16 ***
> b2 -3.288e-04  1.242e-05  -26.47   <2e-16 ***
> ---
> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>
> Residual standard error: 0.5501 on 231 degrees of freedom

## Save fit information for plotting
pred = tec - outs$resid
dfout = data.frame(pred,temp)
dfout = dfout[order(temp),]

## Plot data and predicted curve
par(mfrow=c(1,1),cex=1.25)
plot(temp,tec,xlab=xax,ylab=yax,col="blue")
lines(dfout$temp,dfout$pred)
title(ttl,line=2)
title(ttl2,line=1)

## Residual 6-plot
par(mfrow=c(3,2))
plot(temp,tec,xlab=xax, ylab=yax, main=ttl)
lines(dfout$temp,dfout$pred)
plot(temp,outs$resid, ylab="Residuals", xlab="Temperature (K)",
     main="Residuals vs Temperature")
plot(pred,outs$resid, ylab="Residuals", xlab="Predicted",
     main="Residual vs Predicted")
plot(outs$resid[2:len],outs$resid[1:len-1], ylab="Residuals",
     xlab="Lag 1 Residuals", main="Lag Plot")
hist(outs$resid, ylab="Frequency", xlab="Residuals", 
     main="Histogram")
qqnorm(outs$resid, main="Normal Probability Plot")

## Isolate residual plot
par(mfrow=c(1,1),cex=1.25)
plot(temp,outs$resid, ylab="Residuals", xlab="Temperature (K)",
     main="Residuals from Q/Q Fit", col="blue")
abline(h=0)

## Generate starting values for C/C model
x = c(10,30,40,50,120,200,800)
y = c(0,2,3,5,12,15,20)
x2 = x*x
x3 = x*x*x
xy = -x*y
x2y = -(x*x*y)
x3y = -(x*x*x*y)
sout = lm(y~x+x2+x3+xy+x2y+x3y)
stc = sout$coef
stc

>   (Intercept)             x            x2            x3            xy 
> -2.323648e+00  3.530298e-01 -1.383334e-02  1.766845e-04 -3.395949e-02 
>           x2y           x3y 
>  1.100686e-04  7.910518e-06 

## Fit C/C model
out = nls(tec ~ (a0 + a1*temp + a2*temp**2 + a3*temp**3)/
          (1 + b1*temp + b2*temp**2 + b3*temp**3),
      start=list(a0=stc[1],a1=stc[2],a2=stc[3],a3=stc[4],
               b1=stc[5],b2=stc[6],b3=stc[7]))
outs = summary(out)
outs

> Formula: tec ~ (a0 + a1 * temp + a2 * temp^2 + a3 * temp^3)/(1 + b1 * 
>     temp + b2 * temp^2 + b3 * temp^3)
>
> Parameters:
>      Estimate Std. Error t value Pr(>|t|)    
> a0  1.078e+00  1.707e-01   6.313 1.40e-09 ***
> a1 -1.227e-01  1.200e-02 -10.224  < 2e-16 ***
> a2  4.086e-03  2.251e-04  18.155  < 2e-16 ***
> a3 -1.426e-06  2.758e-07  -5.172 5.06e-07 ***
> b1 -5.761e-03  2.471e-04 -23.312  < 2e-16 ***
> b2  2.405e-04  1.045e-05  23.019  < 2e-16 ***
> b3 -1.231e-07  1.303e-08  -9.453  < 2e-16 ***
> ---
> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>
> Residual standard error: 0.0818 on 229 degrees of freedom

## Save fit information for plotting
pred = tec - outs$resid
dfout = data.frame(pred,temp)
dfout = dfout[order(temp),]

## Plot data and predicted curve
par(mfrow=c(1,1),cex=1.25)
plot(temp,tec,xlab=xax,ylab=yax,col="blue")
lines(dfout$temp,dfout$pred)
title(ttl,line=2)
title(ttl2,line=1)

## Residual 6-plot
par(mfrow=c(3,2))
plot(temp,tec,xlab=xax, ylab=yax, main=ttl)
lines(dfout$temp,dfout$pred)
plot(temp,outs$resid, ylab="Residuals", xlab="Temperature (K)",
     main="Residuals vs Temperature")
plot(pred,outs$resid, ylab="Residuals", xlab="Predicted",
     main="Residual vs Predicted")
plot(outs$resid[2:len],outs$resid[1:len-1], ylab="Residuals",
     xlab="Lag 1 Residuals", main="Lag Plot")
hist(outs$resid, ylab="Frequency", xlab="Residuals", 
     main="Histogram")
qqnorm(outs$resid, main="Normal Probability Plot")

## Isolate residual plot
par(mfrow=c(1,1),cex=1.25)
plot(temp,outs$resid, ylab="Residuals", xlab="Temperature (K)",
     main="Residuals from C/C Fit",col="blue")
abline(h=0)








