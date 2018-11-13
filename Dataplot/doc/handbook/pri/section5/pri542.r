R code and output:

## Input data.
m = matrix(
c(0.0, 0.0, 1.0, 16.8,
0.0, 0.0, 1.0, 16.0,
0.0, 0.5, 0.5, 10.0,
0.0, 0.5, 0.5,  9.7,
0.0, 0.5, 0.5, 11.8,
0.0, 1.0, 0.0,  8.8,
0.0, 1.0, 0.0, 10.0,
0.5, 0.0, 0.5, 17.7,
0.5, 0.0, 0.5, 16.4,
0.5, 0.0, 0.5, 16.6,
0.5, 0.5, 0.0, 15.0,
0.5, 0.5, 0.0, 14.8,
0.5, 0.5, 0.0, 16.1,
1.0, 0.0, 0.0, 11.0,
1.0, 0.0, 0.0, 12.4), ncol=4, byrow=T)

x1 = m[,1]
x2 = m[,2]
x3 = m[,3]
y  = m[,4]


## Fit model to data.
m1 = lm(y ~ -1 + x1 + x2 + x3 + x1*x2 + x1*x3 + x2*x3)

## Combine model effects for F test.
q = anova(m1)
mss = sum(q[1:6,2])
mdof = round(sum(q[1:6,1]),1)
mmse = mss/mdof
rss = q[7,2]
rdof = q[7,1]
mse = rss/rdof

## Combine and print results.
residual = c(rdof,rss,mse,NA,NA)
model = c(mdof,mss,mmse,mmse/mse,df(mmse/mse,mdof,rdof))
a = data.frame(rbind(model,residual))
names(a) = c("DOF","Sum-of-Squares","MSE","F Value","Prob > F")
a

>          DOF Sum-of-Squares         MSE F Value     Prob > F
> model      6        2878.27 479.7116667 658.141 1.547746e-13
> residual   9           6.56   0.7288889      NA           NA

## Print summary of model fit.
summary(m1)

> Call:
> lm(formula = y ~ -1 + x1 + x2 + x3 + x1 * x2 + x1 * x3 + x2 * 
>     x3)
>
> Residuals:
>    Min     1Q Median     3Q    Max 
>  -0.80  -0.50  -0.30   0.65   1.30 
>
> Coefficients:
>       Estimate Std. Error t value Pr(>|t|)    
> x1     11.7000     0.6037  19.381 1.20e-08 ***
> x2      9.4000     0.6037  15.571 8.15e-08 ***
> x3     16.4000     0.6037  27.166 6.01e-10 ***
> x1:x2  19.0000     2.6082   7.285 4.64e-05 ***
> x1:x3  11.4000     2.6082   4.371  0.00180 ** 
> x2:x3  -9.6000     2.6082  -3.681  0.00507 ** 
> ---
> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
>
> Residual standard error: 0.8537 on 9 degrees of freedom
> Multiple R-squared: 0.9977,     Adjusted R-squared: 0.9962 
> F-statistic: 658.1 on 6 and 9 DF,  p-value: 2.271e-11 


## Generate triangular plot.
## Attach lattice library.
library(lattice)

## Generate triangular area for plotting.
trian <- expand.grid(base=seq(0,1,l=100*2), high=seq(0,sin(pi/3),l=87*2))
trian <- subset(trian, (base*sin(pi/3)*2)>high)
trian <- subset(trian, ((1-base)*sin(pi/3)*2)>high)

new <- data.frame(x2=trian$high*2/sqrt(3))
new$x3 <- trian$base-trian$high/sqrt(3)
new$x1 <- 1-new$x3-new$x2

## Predict triangular surface based on regression model.
trian$yhat <- predict(m1, newdata=new)

## Create function to place grid lines and axis labels on the plot.
grade.trellis <- function(from=0.2, to=0.8, step=0.2, col=1, lty=2, lwd=0.5){
  x1 <- seq(from, to, step)
  x2 <- x1/2
  y2 <- x1*sqrt(3)/2
  x3 <- (1-x1)*0.5+x1
  y3 <- sqrt(3)/2-x1*sqrt(3)/2
  panel.segments(x1, 0, x2, y2, col=col, lty=lty, lwd=lwd)
  panel.text(x1, 0, label=x1, pos=1)
  panel.segments(x1, 0, x3, y3, col=col, lty=lty, lwd=lwd)
  panel.text(x2, y2, label=rev(x1), pos=2)
  panel.segments(x2, y2, 1-x2, y2, col=col, lty=lty, lwd=lwd)
  panel.text(x3, y3, label=rev(x1), pos=4)
}

## Generate triangular contour plot.
levelplot(yhat~base*high, trian, aspect="iso", xlim=c(-0.1,1.1), ylim=c(-0.1,0.96),
          xlab=NULL, ylab=NULL, contour=TRUE, labels=FALSE, colorkey=TRUE,
          par.settings=list(axis.line=list(col=NA), axis.text=list(col=NA)))
trellis.focus("panel", 1, 1, highlight=FALSE)
panel.segments(c(0,0,0.5), c(0,0,sqrt(3)/2), c(1,1/2,1), c(0,sqrt(3)/2,0))
grade.trellis()
panel.text(.9,.45,label="x2",pos=2)
panel.text(.1,.45,label="x1",pos=4)
panel.text(.5,-.05,label="x3",pos=1)
trellis.unfocus()
