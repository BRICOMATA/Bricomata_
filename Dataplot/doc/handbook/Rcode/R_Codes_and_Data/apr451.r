R commands and output:

## The qchisq function requires left tail probability inputs. 
## LOWER = T*2 / qchisq(1-alpha/2, df=2*(r+1))
## UPPER = T*2 / qchisq(alpha/2, df=2*r)

## Example.
LOWER=1600/ qchisq(0.95, df=6)
LOWER

##> [1] 127.0690

UPPER=1600 / qchisq(.05,df=4)
UPPER

##> [1] 2251.229
  