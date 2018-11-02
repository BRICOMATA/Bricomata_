\name{gmbs}
\alias{gmbs}

\title{Graphical method estimation (GME) plot}

\description{
The function \code{gmbs()} estimates the parameters alpha and beta of the BSD from a sample of observations by using the graphical
method (GME) developed by Chang and Tang (1994). In addition, the function \code{gmbs()} produces a GME plot for the BSD based on the least squares method.
}

\usage{
gmbs(x)
}

\arguments{
  \item{x}{Vector of observations.}
}

\references{
D.S. Chang and L.C. Tang (1994). Graphical analysis for Birnbaum-Saunders distribution. Microelectronics and Reliability, 34(1): 17-22.
}

\author{Víctor Leiva <victor.leiva@uv.cl>, Hugo Hernández <hugo.hernande@msn.com>, and Marco Riquelme <mriquelm@ucm.cl>.}

\examples{
## Load data sets
data(psi31)
sample<-psi31

gmbs(sample)
}

\keyword{univar}
\keyword{aplot}
