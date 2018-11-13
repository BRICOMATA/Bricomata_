R commands and output:

## Load survival package.
require(survival)

## Input data for Cell 1 - 85 degrees.
cell85 = c(401, 428, 695, 725, 738)
NC85 = 100

## Create survival object.
y85 = Surv(c(cell85, rep(1000, NC85-length(cell85))), 
      c(rep(1,length(cell85)), rep(0, NC85-length(cell85))))

## Generate survival curve (Kaplan-Meier).
ys85 = survfit(y85 ~ 1, type="kaplan-meier")
summary(ys85)

> Call: survfit(formula = y85 ~ 1, type = "kaplan-meier")
> 
>  time n.risk n.event survival std.err lower 95% CI upper 95% CI
>   401    100       1     0.99 0.00995        0.971        1.000
>   428     99       1     0.98 0.01400        0.953        1.000
>   695     98       1     0.97 0.01706        0.937        1.000
>   725     97       1     0.96 0.01960        0.922        0.999
>   738     96       1     0.95 0.02179        0.908        0.994

plot(ys85, xlab="Hours", ylab="Survival Probability", col="red")

## Lognormal Fit.
yl85 = survreg(y85 ~ 1, dist="lognormal")
summary(yl85)

> Call:
> survreg(formula = y85 ~ 1, dist = "lognormal")
>             Value Std. Error      z        p
> (Intercept) 8.891      0.890  9.991 1.67e-23
> Log(scale)  0.192      0.406  0.473 6.36e-01
> 
> Scale= 1.21 
> 
> Log Normal distribution
> Loglik(model)= -53.4   Loglik(intercept only)= -53.4
> Number of Newton-Raphson Iterations: 10 
> n= 100 


## Input data for Cell 2 - 105 degrees.
NC105 = 50
cell105 = c(171, 187, 189, 266, 275, 285, 301, 302, 305, 
            316, 317, 324, 349, 350, 386, 405, 480, 493, 
            530, 534, 536, 567, 589, 598, 599, 614, 620, 
            650, 668, 685, 718, 795, 854, 917,  926)

## Create survival object.
y105= Surv(c(cell105, rep(1000, NC105-length(cell105))), 
           c(rep(1,length(cell105)), rep(0,NC105-length(cell105))))

## Generate survival curve (Kaplan-Meier).
ys105 = survfit(y105 ~ 1, type="kaplan-meier")
summary(ys105)

> Call: survfit(formula = y105 ~ 1, type = "kaplan-meier")
> 
>  time n.risk n.event survival std.err lower 95% CI upper 95% CI
>   171     50       1     0.98  0.0198        0.942        1.000
>   187     49       1     0.96  0.0277        0.907        1.000
>   189     48       1     0.94  0.0336        0.876        1.000
>   266     47       1     0.92  0.0384        0.848        0.998
>   275     46       1     0.90  0.0424        0.821        0.987
>   285     45       1     0.88  0.0460        0.794        0.975
>   301     44       1     0.86  0.0491        0.769        0.962
>   302     43       1     0.84  0.0518        0.744        0.948
>   305     42       1     0.82  0.0543        0.720        0.934
>   316     41       1     0.80  0.0566        0.696        0.919
>   317     40       1     0.78  0.0586        0.673        0.904
>   324     39       1     0.76  0.0604        0.650        0.888
>   349     38       1     0.74  0.0620        0.628        0.872
>   350     37       1     0.72  0.0635        0.606        0.856
>   386     36       1     0.70  0.0648        0.584        0.839
>   405     35       1     0.68  0.0660        0.562        0.822
>   480     34       1     0.66  0.0670        0.541        0.805
>   493     33       1     0.64  0.0679        0.520        0.788
>   530     32       1     0.62  0.0686        0.499        0.770
>   534     31       1     0.60  0.0693        0.478        0.752
>   536     30       1     0.58  0.0698        0.458        0.734
>   567     29       1     0.56  0.0702        0.438        0.716
>   589     28       1     0.54  0.0705        0.418        0.697
>   598     27       1     0.52  0.0707        0.398        0.679
>   599     26       1     0.50  0.0707        0.379        0.660
>   614     25       1     0.48  0.0707        0.360        0.641
>   620     24       1     0.46  0.0705        0.341        0.621
>   650     23       1     0.44  0.0702        0.322        0.602
>   668     22       1     0.42  0.0698        0.303        0.582
>   685     21       1     0.40  0.0693        0.285        0.562
>   718     20       1     0.38  0.0686        0.267        0.541
>   795     19       1     0.36  0.0679        0.249        0.521
>   854     18       1     0.34  0.0670        0.231        0.500
>   917     17       1     0.32  0.0660        0.214        0.479
>   926     16       1     0.30  0.0648        0.196        0.458

plot(ys105, xlab="Hours", ylab="Survival Probability", col="green")

## Lognormal Fit
yl105 = survreg(y105 ~ 1, dist="lognormal")
summary(yl105)

> Call:
> survreg(formula = y105 ~ 1, dist = "lognormal")
>              Value Std. Error     z       p
> (Intercept)  6.470      0.108 60.14 0.00000
> Log(scale)  -0.336      0.129 -2.60 0.00923
> 
> Scale= 0.715 
> 
> Log Normal distribution
> Loglik(model)= -265.2   Loglik(intercept only)= -265.2
> Number of Newton-Raphson Iterations: 5 
> n= 50


## Input data for Cell 3 - 125 degrees.
NC125 = 25
cell125 = c(24, 42, 92, 93, 141, 142, 143, 159, 181, 188, 194, 
            199, 207, 213, 243, 256, 259, 290, 294, 305, 392, 
            454, 502 ,696)

## Create survival object.
y125 = Surv(c(cell125, rep(1000, NC125-length(cell125))), 
            c(rep(1,length(cell125)), rep(0,NC125-length(cell125))))

## Generate survival curve (Kaplan-Meier).
ys125 = survfit(y125 ~ 1, type="kaplan-meier")
summary(ys125)

> Call: survfit(formula = y125 ~ 1, type = "kaplan-meier")
> 
>  time n.risk n.event survival std.err lower 95% CI upper 95% CI
>    24     25       1     0.96  0.0392      0.88618        1.000
>    42     24       1     0.92  0.0543      0.81957        1.000
>    92     23       1     0.88  0.0650      0.76141        1.000
>    93     22       1     0.84  0.0733      0.70791        0.997
>   141     21       1     0.80  0.0800      0.65761        0.973
>   142     20       1     0.76  0.0854      0.60974        0.947
>   143     19       1     0.72  0.0898      0.56386        0.919
>   159     18       1     0.68  0.0933      0.51967        0.890
>   181     17       1     0.64  0.0960      0.47698        0.859
>   188     16       1     0.60  0.0980      0.43566        0.826
>   194     15       1     0.56  0.0993      0.39563        0.793
>   199     14       1     0.52  0.0999      0.35681        0.758
>   207     13       1     0.48  0.0999      0.31919        0.722
>   213     12       1     0.44  0.0993      0.28275        0.685
>   243     11       1     0.40  0.0980      0.24749        0.646
>   256     10       1     0.36  0.0960      0.21346        0.607
>   259      9       1     0.32  0.0933      0.18071        0.567
>   290      8       1     0.28  0.0898      0.14934        0.525
>   294      7       1     0.24  0.0854      0.11947        0.482
>   305      6       1     0.20  0.0800      0.09132        0.438
>   392      5       1     0.16  0.0733      0.06517        0.393
>   454      4       1     0.12  0.0650      0.04151        0.347
>   502      3       1     0.08  0.0543      0.02117        0.302
>   696      2       1     0.04  0.0392      0.00586        0.273

plot(ys125, xlab="Hours", ylab="Survival Probability", col="blue")

## Lognormal Fit.
yl125 = survreg(y125 ~ 1, dist="lognormal")
summary(yl125)

> Call:
> survreg(formula = y125 ~ 1, dist = "lognormal")
>             Value Std. Error     z         p
> (Intercept)  5.33      0.163 32.82 3.42e-236
> Log(scale)  -0.21      0.146 -1.44  1.51e-01
> 
> Scale= 0.81 
> 
> Log Normal distribution
> Loglik(model)= -156.5   Loglik(intercept only)= -156.5
> Number of Newton-Raphson Iterations: 5 
> n= 25


## Plot three survival curves on the same graph.
plot(ys85, xlab="Hours", ylab="Survival Probability", col='red')
points(ys85$time, ys85$surv, col='red', pch=20)

points(ys105$time, ys105$surv, col='green', pch=1)
lines(ys105$time, ys105$surv, col='green')
lines(ys105$time, ys105$upper, col='green', lty=2)
lines(ys105$time, ys105$lower, col='green', lty=2)

points(ys125$time, ys125$surv, col='blue', pch=15, cex=0.9)
lines(ys125$time, ys125$surv, col='blue')
lines(ys125$time, ys125$upper, col='blue', lty=2)
lines(ys125$time, ys125$lower, col='blue', lty=2)

legend('bottomleft', legend=c(85,105,125), lty=c(1,1,1),
       pch=c(20,1,15), cex=0.9, col=c('red','green','blue'))


## Fit the overall Arrhhenius model.
y.All = rbind(y85, y105, y125)
y.all = Surv(y.All[,1], y.All[,2])
k = 8.617e-5
TempC = c(rep(85,NC85), rep(105,NC105), rep(125,NC125))
T = TempC + 273.16
lkT = 1/(k*T)

ylkT = survreg(y.all ~ lkT, dist="lognormal")
summary(ylkT)

> Call:
> survreg(formula = y.all ~ lkT, dist = "lognormal")
>               Value Std. Error     z        p
> (Intercept) -19.906     2.3204 -8.58 9.60e-18
> lkT           0.863     0.0761 11.34 7.89e-30
> Log(scale)   -0.259     0.0928 -2.79 5.32e-03
> 
> Scale= 0.772 
> 
> Log Normal distribution
> Loglik(model)= -476.7   Loglik(intercept only)= -551
>         Chisq= 148.58 on 1 degrees of freedom, p= 0 
> Number of Newton-Raphson Iterations: 6 
> n= 175 


## Perform likelihood ratio test to see if the Arrhenius
## model is better than the individual cell fits.

## Combine ln likelihood values for three model.
lnL1 = yl85$loglik[1] + yl105$loglik[1] + yl125$loglik[1]
lnL1

> [1] -475.1119

## Save ln likelihood for Arrhenius model (acceleration model).
lnL0 = ylkT$loglik[2]
lnL0

> [1] -476.7089

## Compute -2 ln likelihood
lr = -2*(lnL0 - lnL1)
lr

> [1] 3.194015

## Chi-square critical value.
qchisq(0.95,3)

> [1] 7.814728

## Chi-square p-value.
1-pchisq(lr,3)

> [1] 0.3626682

