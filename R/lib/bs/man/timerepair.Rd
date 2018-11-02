\name{timerepair}
\alias{timerepair}
\docType{data}

\title{Maintenance data}

\description{
Several data sets related to the BSD are available in the bs package, which have been taken from the literature on this topic.
}

\usage{data(timerepair)}

\format{
A vector containing 46 observations.
}

\details{
\code{timerepair} correspond to maintenance data on active repair times (in hours) for an airborne communications transceiver.
}

\references{
Hsieh, H. K. (1990). Estimating the Critical Time of Inverse Gaussian Hazard Rate. IEEE Transactions on Reliability, 39(10): 342-345.
}

\examples{
## Load data sets
data(timerepair)
## Histogram for timerepair
hist(timerepair)
}

\keyword{datasets}
