\name{rbs1}
\alias{rbs1}

\title{Random number generator from BSD (G1)}

\description{
Generate random numbers from the BSD with shape parameter alpha and scale parameter beta. \code{rbs1()} is based on the
relationship between the standard normal distribution and the BSD; see Chang and Tang (1994).
}

\usage{
rbs1(n, alpha = 1, beta = 1)
}

\arguments{
  \item{n}{Number of observations.}
  \item{alpha}{Shape parameter.}
  \item{beta}{Scale parameter.}
}

\value{
\code{rbs1()} gives a vector of n random numbers from the BSD for alpha and beta.
}

\references{
Chang D. S. and Tang, L. C. (1994). Random number generator for the Birnbaum-Saunders distribution. Computational and Industrial Engineering, 27(1-4):345-348.
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
