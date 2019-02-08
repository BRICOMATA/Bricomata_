\name{ksbs}
\alias{ksbs}

\title{Test of Kolmogorov-Smirnov for the Birnbaum-Saunders distribution}

\description{
The function \code{ksbs()} gives the values for the KS test assuming an BSD with shape parameter alpha and scale parameter beta.
In addition, optionally, this function allows one to show a comparative graph between the empirical and theoretical cdfs for a specified data set.
}

\usage{
ksbs(x, alternative = c("less", "two.sided", "greater"), plot = FALSE)
}

\arguments{
  \item{x}{Vector of observations.}
  \item{alternative}{indicates the alternative hypothesis and must be one of \code{"two.sided"} (default), \code{"less"}, or \code{"greater"}.}
  \item{plot}{Logical; if TRUE, the cdf plot is provided. }
}

\details{
The Kolmogorov-Smirnov test is a goodness-of-fit technique based on the maximum distance between the empirical and theoretical cdfs.
}

\value{
The function \code{ksbs()} carries out the KS test for the BSD.
}

\author{Víctor Leiva <victor.leiva@uv.cl>, Hugo Hernández <hugo.hernande@msn.com>, and Marco Riquelme <mriquelm@ucm.cl>.}

\examples{
## Load data sets
data(psi31)
sample<-psi31

## KS test for psi31
ksbs(sample,plot=FALSE,alternative="two.sided")
}

\keyword{univar}
