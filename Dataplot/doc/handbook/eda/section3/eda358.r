R commands and output:

## Read data.
m <- matrix(scan("gear.dat",skip=25),ncol=2,byrow=T)
diameter = m[,1]

## Create function to perform chi-square test.
var.interval = function(data,sigma0,conf.level = 0.95) {
  df = length(data) - 1
  chilower = qchisq((1 - conf.level)/2, df)
  chiupper = qchisq((1 - conf.level)/2, df, lower.tail = FALSE)
  v = var(data)
  testchi = df*v/(sigma0^2)
  alpha = 1-conf.level

  print(paste("Standard deviation = ", round(sqrt(v),4)),quote=FALSE)
  print(paste("Test statistic = ", round(testchi,4)),quote=FALSE)
  print(paste("Degrees of freedom = ", round(df,0)),quote=FALSE)
  print(" ",quote=FALSE)
  print("Two-tailed test critical values, alpha=0.05",quote=FALSE)
  print(paste("Lower = ", round(qchisq(alpha/2,df),4)),quote=FALSE)
  print(paste("Upper = ", round(qchisq(1-alpha/2,df),4)),quote=FALSE)
  print(" ",quote=FALSE)
  print("95% Confidence Interval for Standard Deviation",quote=FALSE)
  print(c(round(sqrt(df * v/chiupper),4), 
         round(sqrt(df * v/chilower),4)),quote=FALSE)
}

## Perform chi-square test.
 var.interval(diameter,0.1)

> [1] Standard deviation =  0.0063
> [1] Test statistic =  0.3903
> [1] Degrees of freedom =  99
> [1]  
> [1] Two-tailed test critical values, alpha=0.05
> [1] Lower =  73.3611
> [1] Upper =  128.422
> [1]  
> [1] 95% Confidence Interval for Standard Deviation
> [1] 0.0055 0.0073