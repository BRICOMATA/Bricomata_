\name{sicbs}
\alias{sicbs}

\title{Schwartz information criterium (SIC) for a sample of the BSD}

\description{
The function \code{sicbs()} gives the SIC value assuming an BSD with parameters alpha and beta. 
\code{sicbs()} is based on the invariance property of the MLE.
}
\usage{
sicbs(x)
}
%- maybe also 'usage' for other objects documented here.

\arguments{
  \item{x}{Vector of observations.}
}

\details{
The SIC is a selection model criterion based on information loss. According to this criterion,
it is possible to choose a hypothetic model that better describe to the data set considering the smaller SIC value.
The SIC is defined as \eqn{SIC  = -l(\theta)/n+ p \log(n)/(2n)}, where \eqn{l(\theta)} is the log-likelihood function
associated with the model, n is the sample size, and p is the number of involved parameters;
for more details see Spieglhaiter, Best, Carlin and van der Linde (2002).
}

\value{
The function \code{sicbs()} gives the SIC value.
}

\references{Schwarz, S. (1978). Estimating the dimension of the model. Annals of Statistics, 6, 461-464.

Spieglhaiter, D. J., Best, N. G., Carlin, B. P. and van der Linde, A. (2002). Bayesian measures of complexity and fit. Journal of the Royal Statistical Society Series B 64, 1-34.

Leiva, V., Hernández, H., and Riquelme, M. (2006). A New Package for the Birnbaum-Saunders Distribution. Rnews, 6/4, 35-40. (http://www.r-project.org)
}

\author{Víctor Leiva <victor.leiva@uv.cl>, Hugo Hernández <hugo.hernande@msn.com>, and Marco Riquelme <mriquelm@ucm.cl>.}

\examples{
## Load data sets
data(psi31)

## Calculus of SIC for psi31
sicbs(psi31)
}

\keyword{univar}
