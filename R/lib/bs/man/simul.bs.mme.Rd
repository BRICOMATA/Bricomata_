\name{simul.bs.mme}
\alias{simul.bs.mme}

\title{Simulation study by using MME method}

\description{
The function \code{simul.bs.mme()} simulates three samples of size \eqn{n} from a
population \eqn{T \sim \rm{BS}(alpha,beta)}{T ~ BS(alpha,beta)}, one for each method (\code{rbs1()}, \code{rbs2()}, or \code{rbs3()}), computes the MMES's
for alpha and beta, and establish goodness-of-fit for each sample.
}

\usage{
simul.bs.mme(n, alpha, beta)
}

\arguments{
  \item{n}{Samples of size \code{n}.}
  \item{alpha}{Teorical shape parameter for simulations.}
  \item{beta}{Teorical scale parameter for simulations.}
}

\details{
In order to carry out simulation studies, we develop the functions \code{simul.bs.gme()},
\code{simul.bs.mle()}, and \code{simul.bs.mme()}. These functions generate random samples, estimate parameters,
and establish goodness-of-fit. The samples of size \eqn{n}, one for each method (G1, G2, or G3), are generated
by using \code{rbs1()}, \code{rbs2()}, and \code{rbs3()}, respectively. The estimations, one for each method,
are obtained by using \code{est1bs()}, \code{est2bs()}, and \code{est3bs()}, respectively. The goodness-of-fit
method is based on the statistic of Kolmogorov-Smirnov (KS), which is available through the
function \code{ksbs()}. The generated observations by means of G1, G2, and G3 are saved as slots of the
\code{R class simulBsClass}, which are named \code{sample1}, \code{sample2}, and \code{sample3}, respectively. Furthermore,
the results of the simulation study are saved in a fourth slot of this class, named \code{results}.
}

\value{
An object of class \code{"simulBsClass"} (Slots).
}

\references{Leiva, V., Hernández, H., and Riquelme, M. (2006). A New Package for the Birnbaum-Saunders Distribution. Rnews, 6/4, 35-40. (http://www.r-project.org)}

\author{Víctor Leiva <victor.leiva@uv.cl>, Hugo Hernández <hugo.hernande@msn.com>, and Marco Riquelme <mriquelm@ucm.cl>.}

\examples{
## Example: simul.bs.mle()
simul.bs.mle(100,0.5,1.0)

results<-simul.bs.mle(100,0.5,1.0)
results@results

sample<-results@sample1

## Example: simul.bs.mme()
simul.bs.mme(100,0.5,1.0)

## Example: simul.bs.gme()
simul.bs.gme(100,0.5,1.0)
}

\keyword{univar}
