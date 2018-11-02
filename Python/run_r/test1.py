
#from rpy2.robjects.packages import importr
#distribution = importr('ggallin')

#from rpy2 import robjects
from rpy2.robjects import r
distribution = r.source("distribution.r")
print (distribution)
