\name{bearings}
\alias{bearings}
\docType{data}

\title{Fatigue lifetime data}

\description{
Several data sets related to the BSD are available in the bs package, which have been taken from the literature on this topic.
}

\usage{data(bearings)}

\format{
A vector containing 10 observations.
}

\details{
McCool (1974) gives data related to the fatigue life in hours of 10 bearings of a certain type.
}

\references{
McCool, J. I. (1974). Inferential techniques for Weibull populations. Aerospace Research Laboratories Report ARL TR74-0180, Wright-Patterson Air Force Base, Dayton, OH.
}

\examples{
## Load data sets
data(bearings)
## Histogram for bearings
hist(bearings)
}

\keyword{datasets}
