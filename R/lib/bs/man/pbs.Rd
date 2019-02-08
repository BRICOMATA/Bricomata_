\name{pbs}
\alias{pbs}

\title{Cumulative distribution function (cdf) of the Birnbaum-Saunders distribution}

\description{
Cumulative distribution function of the BSD with shape parameter alpha and scale parameter beta.
}

\usage{
pbs(q, alpha = 1, beta = 1, lower.tail = TRUE, log.p = FALSE)
}

\arguments{
  \item{q}{Vector of quantiles.}
  \item{alpha}{Shape parameter.}
  \item{beta}{Scale parameter.}
  \item{lower.tail}{Logical; if TRUE (default), probabilities are P[X <= x], otherwise, P[X > x].}
  \item{log.p}{Logical; if TRUE, probabilities p are given as log(p).}
}

\details{
Birnbaum and Saunders (1969) proposed the two-parameter Birnbaum-Saunders
distribution with density
\deqn{
f_{T}(t) = \frac{1}{\sqrt{2\pi}} \exp\left[-\frac{1}{2\alpha^{2}}
\left(\frac{t}{\beta}+\frac{\beta}{t}-2\right) \right]
\frac{t^{-\frac{3}{2}} (t+\beta)}{2\alpha\sqrt{\beta}}; \ t>0,
\alpha
> 0, \beta > 0,}
as a failure time distribution for fatigue failure caused under cyclic loading. The parameters
alpha and beta are the shape and the scale parameters, respectively. In their derivation,
it was assumed that the failure is due to the development and growth of a
dominant crack.
}

\value{
\code{pbs()} gives the cdf of an BSD.
}

\references{Birnbaum, Z. W. and Saunders, S. C. (1969). A new family of life distributions. J. Appl. Probab. 6(2): 637-652.}

\author{Víctor Leiva <victor.leiva@uv.cl>, Hugo Hernández <hugo.hernande@msn.com>, and Marco Riquelme <mriquelm@ucm.cl>.}

\examples{
## Load package
library(bs)

## cdf for the Birnbaum-Saunders distribution
## with parameters alpha=0.5 y beta=1.0 in x=3.
pbs(3,alpha=0.5,beta=1.0,log=FALSE)
}

\keyword{distribution}
