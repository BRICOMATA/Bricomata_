\name{indicatorsbs}
\alias{indicatorsbs}

\title{Indicators for the Birbaum-Saunders distribution}

\description{
The function \code{indicatorsbs()} computes the MLE's for alpha, beta, mean, variance, CV, CS and CK for the BSD.
}

\usage{
indicatorsbs(x)
}

\arguments{
  \item{x}{Vector of observations.}
}

\details{
By using the invariance property of the MLE's, we obtain estimations for the mean, the variance,
and the coefficients of variation (CV), skewness (CS), and kurtosis (CK).
}

\value{
The function \code{indicatorsbs()} gives a list of estimations for the alpha, beta, mean, variance, CV,
CS, and CK of BSD.
}

\references{Leiva, V., Hernández, H., and Riquelme, M. (2006). A New Package for the Birnbaum-Saunders Distribution. Rnews, 6/4, 35-40. (http://www.r-project.org)}

\author{Víctor Leiva <victor.leiva@uv.cl>, Hugo Hernández <hugo.hernande@msn.com>, and Marco Riquelme <mriquelm@ucm.cl>.}

\examples{
## Summary for psi31
data(psi31)
sample<-psi31
indicatorsbs(sample)
}

\keyword{univar}
