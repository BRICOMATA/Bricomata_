\name{graphdbs}
\alias{graphdbs}

\title{Visualization of five different pdf's}

\description{
The command \code{graphdbs()} allows the visualization of five different pdf's from the
BSD, but the legend of this must be added.
}

\usage{
graphdbs(a1, a2, a3, a4, a5, b1, b2, b3, b4, b5)
}

\arguments{
  \item{a1}{Shape parameter (first plot).}
  \item{a2}{Shape parameter (second plot).}
  \item{a3}{Shape parameter (third plot).}
  \item{a4}{Shape parameter (fourth plot).}
  \item{a5}{Shape parameter (fifth plot).}
  \item{b1}{Scale parameter (first plot).}
  \item{b2}{Scale parameter (second plot).}
  \item{b3}{Scale parameter (third plot).}
  \item{b4}{Scale parameter (fourth plot).}
  \item{b5}{Scale parameter (first plot).}
}

\author{Víctor Leiva <victor.leiva@uv.cl>, Hugo Hernández <hugo.hernande@msn.com>, and Marco Riquelme <mriquelm@ucm.cl>.}

\examples{
## Figure of pdf's
graphdbs(0.5,0.7,0.9,1.5,2.0,1.0,1.0,1.0,1.0,1.0)

## Legend
legend(3.45,1.25,
c(
"alpha = 0.5",
"alpha = 0.7",
"alpha = 0.9",
"alpha = 1.5",
"alpha = 2.0"),
lty=c(1,1,1,1,1),lwd=c(2,2,2,2,2),
col=c(1,2,3,4,8))

## Figure of fr's
grapfrbs(0.5,0.7,0.9,1.5,2.0,1.0,1.0,1.0,1.0,1.0)

## Legend
legend(3.425,1.875,
c(
"alpha = 0.5",
"alpha = 0.7",
"alpha = 0.9",
"alpha = 1.5",
"alpha = 2.0"),
lty=c(1,1,1,1,1),lwd=c(2,2,2,2,2),
col=c(1,2,3,4,8))
}

\keyword{univar}
