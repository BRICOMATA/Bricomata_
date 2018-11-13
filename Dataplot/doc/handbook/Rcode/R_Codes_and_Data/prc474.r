R commands and output:

## Set the proportions of interest.
p = c(0.120, 0.153, 0.140, 0.210, 0.127)
N = length(p)
value = critical.range = c()

## Compute critical values.
for (i in 1:(N-1))
   { for (j in (i+1):N)
    {
     value = c(value,(abs(p[i]-p[j])))
     critical.range = c(critical.range,
      sqrt(qchisq(.95,4))*sqrt(p[i]*(1-p[i])/300 + p[j]*(1-p[j])/300))
    }
   }

round(cbind(value,critical.range),3)

>       value critical.range
>  [1,] 0.033          0.086
>  [2,] 0.020          0.085
>  [3,] 0.090          0.093
>  [4,] 0.007          0.083
>  [5,] 0.013          0.089
>  [6,] 0.057          0.097
>  [7,] 0.026          0.087
>  [8,] 0.070          0.095
>  [9,] 0.013          0.086
> [10,] 0.083          0.094