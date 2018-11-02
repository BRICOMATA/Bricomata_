\name{est3bs}
\alias{est3bs}

\title{Modified moment estimation (MME) of the Birnbaum-Saunders distribution}

\description{
The function \code{est3bs()} estimates the parameters alpha and beta of the BSD from a sample of observations by using the modified moment method
(MLE); see Ng, Kundub and Balakrishnan (2006).
}

\usage{
est3bs(x)
}

\arguments{
  \item{x}{Vector of observations.}
}

\value{
The function \code{est3bs()} returns a list with two elements:
  \item{alpha}{Estimation of alpha by using MME method.}
  \item{beta}{Estimation of beta by using MME method.}
}

\references{Birnbaum, Z. W. and Saunders, S. C. (1969). Estimation for a family of life distributions with applications to fatigue. J. Appl. Probab. 6(2): 328-347.

Ng, H. K., Kundub, D., Balakrishnan, N. (2006). Point and interval estimation for the two-parameter Birnbaum-Saunders distribution based on Type-II censored samples. Computational Statistics and Data Analysis 50:3222-3242.

Leiva, V., Hernández, H., and Riquelme, M. (2006). A New Package for the Birnbaum-Saunders Distribution. Rnews, 6/4, 35-40. (http://www.r-project.org)
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
