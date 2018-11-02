\name{rbs2}
\alias{rbs2}

\title{Random number generator from BSD (G2)}

\description{
Generate random numbers from the BSD with shape parameter alpha and scale parameter beta. \code{rbs2()} is based
on the relationship between the sinhnormal distribution (SHND) and the BSD; see Rieck (2003).
}

\usage{
rbs2(n, alpha = 1, beta = 1)
}

\arguments{
  \item{n}{Number of observations.}
  \item{alpha}{Shape parameter.}
  \item{beta}{Scale parameter.}
}

\value{
\code{rbs2()} gives a vector of n random numbers from the BSD with specific values alpha and beta.
}

\references{
Rieck, J. R. (2003). A comparison of two random number generators for the Birnbaum-Saunders distribution. Communications in Statistics - Theory and Methods, 32(5):929-934.
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
