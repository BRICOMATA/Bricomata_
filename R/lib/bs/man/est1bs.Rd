\name{est1bs}
\alias{est1bs}

\title{Maximum likelihood estimation (MLE) of the Birnbaum-Saunders distribution}

\description{
The function \code{est1bs()} estimates the parameters alpha and beta of the BSD from a sample of observations by using the likelihood
method (MLE) and the mean-mean estimator; see Birnbaum and Saunders (1969).
}

\usage{
est1bs(x)
}

\arguments{
  \item{x}{Vector of observations.}
}

\value{
The function \code{est1bs()} returns a list with four elements:
  \item{alpha}{Estimation of alpha by using MLE method.}
  \item{beta}{Estimation of beta by using MLE method.}
  \item{beta.start}{Estimation of mean-mean estimator.}
  \item{iterations}{Number of iterations of the process.}
}

\references{
Birnbaum, Z. W. and Saunders, S. C. (1969). Estimation for a family of life distributions with applications to fatigue. J. Appl. Probab. 6(2): 328-347.

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
