\name{est2bs}
\alias{est2bs}

\title{Graphical method estimation (GME) of the Birnbaum-Saunders distribution}

\description{
The function \code{est2bs()} estimates the parameters alpha and beta of the BSD from a sample of observations by using the graphical
method (GME) developed by Chang and Tang (1994). In addition, optionally, the function \code{est2bs()} produces a GME plot for the BSD based on the least squares method.
}

\usage{
est2bs(x, plot = "FALSE")
}

\arguments{
  \item{x}{Vector of observations.}
  \item{plot}{Logical; if TRUE, the GME plot is provided.}
}

\value{
The function \code{est2bs()} returns a list with three elements:
  \item{alpha}{Estimation of alpha by using GME method.}
  \item{beta}{Estimation of beta by using GME method.}
  \item{r.squared}{Coefficient of determination of least squares for GME plot.}
}

\references{
Birnbaum, Z.W. and Saunders, S.C. (1969). Estimation for a family of life distributions with applications to fatigue. J. Appl. Probab. 6(2): 328-347.

Leiva, V., Hernández, H., and Riquelme, M. (2006). A New Package for the Birnbaum-Saunders Distribution. Rnews, 6/4, 35-40. (http://www.r-project.org)

D.S. Chang and L.C. Tang (1994). Graphical analysis for Birnbaum-Saunders distribution. Microelectronics and Reliability, 34(1): 17-22.
}

\author{Víctor Leiva <victor.leiva@uv.cl>, Hugo Hernández <hugo.hernande@msn.com>, and Marco Riquelme <mriquelm@ucm.cl>.}

\examples{
## Load package
library(bs)

## Load data sets
data(psi31)

## Examples for parameters estimation
est1bs(psi31)
est2bs(psi31)
est3bs(psi31)
}

\keyword{univar}
