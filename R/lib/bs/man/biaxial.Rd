\name{biaxial}
\alias{biaxial}
\docType{data}

\title{Brown and Miller's biaxial fatigue data}

\description{
Several data sets related to the BSD are available in the bs package, which have been taken from the literature on this topic.
}

\usage{data(biaxial)}

\format{
A vector containing 46 observations.
}

\details{
Rieck and Nedelman (1991) reported a data set from Brown and Miller (1978). These data represent results of fatigue tests on 1\eqn{\%} Cr-Mo-V steel. Cylindrical specimens were subjected to combined torsional and axial loads over constant-amplitude cycles until failure.
}

\references{
Rieck, J. R. and Nedelman, J. (1991). A Log-Linear Model for the Birnbaum-Saunders Distribution. Technometrics. 33, 51-60.

Brown, M. W. and Miller, K. J. (1978). Biaxial Fatigue Data. Report CEMR1/78. University of Sheffield, Dept. of Mechanical Engineering.
}

\examples{
## Load data sets
data(biaxial)
## Histogram for biaxial
hist(biaxial)
}

\keyword{datasets}
