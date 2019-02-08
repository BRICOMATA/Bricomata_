\name{qqbs}
\alias{qqbs}

\title{Quantile versus quantile (QQ) plot for the the BSD}

\description{
The function \code{qqbs()} produces a QQ plot for the BSD based on their MLE. Also, a line going through the first and
the third quartile can be sketched.
}

\usage{
qqbs(x, line = FALSE, xlab = "Empirical quantiles", ylab = "Theoretical quantiles")
}

\arguments{
  \item{x}{Vector of observations.}
  \item{line}{Logical; if TRUE, a line going by the first and third quartile is sketched.}
  \item{xlab}{A title for the x axis.}
  \item{ylab}{A title for the y axis.}
}

\value{
The function \code{qqbs()} carries out a QQ plot for the BSD.
}

\references{
Birnbaum, Z. W. and Saunders, S. C. (1969). A new family of life distributions. J. Appl. Probab. 6(2): 637-652.
}

\author{Víctor Leiva <victor.leiva@uv.cl>, Hugo Hernández <hugo.hernande@msn.com>, and Marco Riquelme <mriquelm@ucm.cl>.}

\examples{
## Load data sets
data(psi31)
sample<-psi31

## QQ plot for psi31
qqbs(sample,line=TRUE)

## PP plot for psi31
ppbs(sample,line=TRUE)
}

\keyword{univar}
\keyword{aplot}
