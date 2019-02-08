\name{rbs}
\alias{rbs}

\title{Random number generator from the Birnbaum-Saunders distribution}

\description{
Generate random numbers from the BSD with shape parameter alpha and scale parameter beta. The function \code{rbs()}
selects the most appropriate method automatically. For details about effectiveness and efficiency
of these three generators and the way to select the most suitable one see Leiva et al. (2006).
}

\usage{
rbs(n, alpha = 1, beta = 1)
}

\arguments{
  \item{n}{Number of observations.}
  \item{alpha}{Shape parameter.}
  \item{beta}{Scale parameter.}
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
alpha and bata are the shape and the scale parameters, respectively. In their derivation,
it was assumed that the failure is due to the development and growth of a
dominant crack.
}

\value{
\code{rbs()} gives a vector of n random numbers from the BSD with specific values of alpha and beta.
}

\references{
Chang D. S. and Tang, L. C. (1994). Random number generator for the Birnbaum-Saunders distribution. Computational and Industrial Engineering, 27(1-4):345-348.

Leiva, V., Sanhueza, A., Sen, P. K., and Paula, G. A. (2006). Random number generators for the generalized Birnbaum-Saunders distribution. Submitted to Publication.

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
