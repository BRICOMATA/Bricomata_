\name{bs-package}
\alias{bs-package}
\alias{bs}
\docType{package}

\title{
Package for the Birnbaum-Saunders distribution.
}

\description{
A collection of utilities for the Birnbaum-Saunders distribution (BSD).
}

\details{
\tabular{ll}{
Package: \tab bs\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2007-09-03\cr
License: \tab GPL\cr
}
Birnbaum and Saunders (1969) proposed a two-parameter failure time distribution for
fatigue failure caused under cyclic loading. It was also assumed that the failure is due
to the development and growth of a dominant crack.
}

\author{
Víctor Leiva <victor.leiva@uv.cl>, Hugo Hernández <hugo.hernande@msn.com>, and Marco Riquelme <mriquelm@ucm.cl>.

Maintainer: Hugo Hernández <hugo.hernandez@msn.com>.
}

\references{
Birnbaum, Z. W. and Saunders, S. C. (1969). A new family of life distributions. J. Appl. Probab. 6(2): 637-652.

Leiva, V., Hernández, H., and Riquelme, M. (2006). A New Package for the Birnbaum-Saunders Distribution. Rnews, 6/4, 35-40. (http://www.r-project.org)
}

\keyword{package}

\examples{
## Load package
library(bs)

## density for the Birnbaum-Saunders distribution
## with parameters alpha=0.5 y beta=1.0 in x=3.
dbs(3,alpha=0.5,beta=1.0,log=FALSE)
}
