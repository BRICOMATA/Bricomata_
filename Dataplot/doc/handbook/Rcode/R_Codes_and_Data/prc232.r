R commands and output:

## Input constants.
d=55
v = 100
r = 1 + d/v

## Find the root of the function.
cnu = function(nu){pchisq(qchisq(.95,nu)/r,nu) - 0.01}
size = uniroot(cnu,c(1,200))
size$root

> [1] 169.3335

## Generate table of sample sizes.
x=matrix(nrow=200, ncol=3)
for(nu in (1:200)){
bnu = qchisq(.95,nu)
bnu=bnu/r
cnu=pchisq(bnu,nu)
x[nu,1] = nu
x[nu,2] = bnu
x[nu,3] = cnu}
print(x[165:175,])

>      nu      bnu         cnu
> 165 165 126.4344 0.011366199
> 166 166 127.1380 0.011035681
> 167 167 127.8414 0.010714513
> 168 168 128.5446 0.010402441
> 169 169 129.2477 0.010099215
> 170 170 129.9506 0.009804594
> 171 171 130.6533 0.009518341
> 172 172 131.3558 0.009240228
> 173 173 132.0582 0.008970030
> 174 174 132.7604 0.008707531
> 175 175 133.4625 0.008452517