\name{rbs3}
\alias{rbs3}

\title{Random number generator from BSD (G3)}

\description{
Generate random numbers from the BSD with shape parameter alpha and scale parameter beta. \code{rbs3()} is based
on the relationship between the inverse Gaussian distribution (IGD) and the BSD; see Johnson et al. (1994).
}

\usage{
rbs3(n, alpha = 1, beta = 1)
}

\arguments{
  \item{n}{Number of observations.}
  \item{alpha}{Shape parameter.}
  \item{beta}{Scale parameter.}
}

\value{
\code{rbs3()} gives a vector of n random numbers from the BSD with specific values alpha and beta.
}

\references{
Johnson, N. L., Kotz, S. and Balakrishnan, N. (1994). Continuous Univariate Distributions: Volume 2. Wiley, New York.

Leiva, V., Sanhueza, A., Sen, P. K., and Paula, G. A. (2006). Random number generators for the generalized Birnbaum-Saunders distribution. Submitted to Publication.
}

\author{Víctor Leiva <victor.leiva@uv.cl>, Hugo Hernández <hugo.hernande@msn.com>, and Marco Riquelme <mriquelm@ucm.cl>.}

\examples{
## Examples for simulations
rbs1(n=6,alpha=0.5,beta=1.0)
rbs2(n=6,alpha=0.5,beta=1.0)
rbs3(n=6,alpha=0.5,beta=1.0)

rbs(n=6,alpha=0.5,beta=1.0)

sample<-rbs(n=100,alpha=0.5,beta=1.0)
## Higtogram for sample
hist(sample)
}

\keyword{distribution}
