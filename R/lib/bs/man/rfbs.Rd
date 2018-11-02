\name{rfbs}
\alias{rfbs}

\title{Reliability function (rf) of the BSD}

\description{
Survival function (or reliability function) of the BSD with shape parameter alpha and scale parameter beta.
}

\usage{
rfbs(x, alpha = 1, beta = 1)
}

\arguments{
  \item{x}{Vector of quantiles.}
  \item{alpha}{Shape parameter.}
  \item{beta}{Scale parameter.}
}

\details{
One of the useful indicators in lifetime analysis is the hazard function (h.f.), which is defined by
\deqn{
h_T(t) = \frac{f_T(t)}{1- F_T(t)},\, t > 0,\, 0<F_T(t)<1,
}
where \eqn{f_T(\cdot)} and \eqn{F_T(\cdot)} are the pdf and cdf, respectively;
see e.g. Johnson, Kotz, and Balakrishnan (1994, p.
640). The behavior of \eqn{h_T(t)} allows one to characterize the aging
of the units. For example, if the failure rate is increasing (IFR
class), then the units age with time. If \eqn{h_T(t)} is decreasing (DFR
class), then the units improve in performance with time. Finally, if
\eqn{h_T(t)} is constant, then the lifetime distribution is necessarily
the exponential one.

Another aging indicators are the following:

The failure rate average (FRA) of T is given by
\deqn{
FRA(t) = \frac{H_T(t)}{t} = \frac{\int^{t}_{0}
h_T(t)\,dt}{t},\, t>0,
}
where \eqn{H_T(t)} is the cumulative hazard function. An analysis for
FRA(\eqn{t}) on \eqn{t} permits to obtain the IFRA and DFRA classes.

The survival function (s.f.) and the conditional survival of T
are defined by
\deqn{
R_T(t) = 1- F_T(t) \quad {\rm and} \quad R_T(t|x) =
\frac{R_T(t+x)}{R_T(x)},\, t >0,\, x> 0,\, R_T(\cdot) > 0,
}
respectively, where \eqn{F_T(\cdot)} is the cdf of T. Similarly to
\eqn{h_T(t)} and \eqn{FRA(t)}, the distribution of T belongs to the
new better than used (NBU), exponential, or new worse than used (NWU)
classes, when \eqn{R_T(t|x) < R_T(t)}, \eqn{R_T(t|x) = R_T(t)},
or \eqn{R_T(t|x) > R_T(t)}, respectively.
}

\value{
Survival function for the BSD.
}

\references{Hoyland, A. and Rausand, M. (1994). System Reliability Theory. John Wiley and Sons. N. Y.}

\author{Víctor Leiva <victor.leiva@uv.cl>, Hugo Hernández <hugo.hernande@msn.com>, and Marco Riquelme <mriquelm@ucm.cl>.}

\examples{
## Reliability indicators:

## Reliability function
rfbs(3,0.5,1.0)

## Conditional reliability function
crfbs(3,0,0.5,1.0)

## Conditional reliability function (age component=0)
crfbs(3,x=0,0.5,1.0)

## Conditional reliability function (age component=0)
crfbs(3,x=2,0.5,1.0)

## failure rate
frbs(3,0.5,1.0)

## failure rate average
frabs(3,0.5,1.0)
}

\keyword{univar}
\keyword{survival}
