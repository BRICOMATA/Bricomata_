\name{psi21}
\alias{psi21}
\docType{data}

\title{Lifetimes of aluminum specimens exposed to a maximum stress of 21,000 psi.}

\description{
Several data sets related to the BSD are available in the bs package, which have been taken from the literature on this topic.
}

\usage{data(psi21)}

\format{
A vector containing 101 observations.
}

\details{
psi21, psi26 and psi31 were taken from Birnbaum and Saunders (1969), who reported fatigue life data correspond to the cycles (\eqn{\times 10^{-3}}) of aluminum specimens of type 6061-T6. These specimens were cut in a parallel angle to the direction of rotation and oscillating at 18 cycles per seconds. They were exposed to a pressure with maximum stress of 21,000, 26,000, and 31,000 psi (pounds per square inch), for \eqn{n = 101, 102,} and \eqn{101} specimens, respectively.
}

\references{
Birnbaum, Z. W. and Saunders, S. C. (1969). Estimation for a family of life distributions with applications to fatigue. J. Appl. Probab. 6(2): 328-347.
}

\examples{
## Load data sets
data(psi21)
## Histogram for psi21
hist(psi21)
}

\keyword{datasets}
