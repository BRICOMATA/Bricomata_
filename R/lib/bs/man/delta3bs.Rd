\name{delta3bs}
\alias{delta3bs}

\title{The coefficient of skewness for the BSD}

\description{
Estimation of the coefficient of skewness (CS) for the Birnbaum-Saunders distribution.
}

\usage{
delta3bs(x)
}

\arguments{
  \item{x}{Vector of observations.}
}

\details{
Methods of goodness-of-fit based on moments (\eqn{\delta_2-\delta_3} chart).
}

\value{
The function \code{delta3bs()} gives the CS value.
}

\references{Leiva, V., Hernández, H., and Riquelme, M. (2006). A New Package for the Birnbaum-Saunders Distribution. Rnews, 6/4, 35-40. (http://www.r-project.org)}

\author{Víctor Leiva <victor.leiva@uv.cl>, Hugo Hernández <hugo.hernande@msn.com>, and Marco Riquelme <mriquelm@ucm.cl>.}

\examples{
## delta2-delta3 chart
## Example: 12 BSD samples have been simulated by using 'rbs()' for the values
## alfa = 0.2,0.4,0.5,0.6,0.8,1.0,1.2,1.4,1.8,2.0,2.2,2.4
## beta = 1.0
sample1<-rbs(30,0.2,1.0)
sample2<-rbs(30,0.4,1.0)
sample3<-rbs(30,0.6,1.0)
sample4<-rbs(30,0.8,1.0)
sample5<-rbs(30,1.0,1.0)
sample6<-rbs(30,1.2,1.0)
sample7<-rbs(30,1.4,1.0)
sample8<-rbs(30,1.6,1.0)
sample9<-rbs(30,1.8,1.0)
sample10<-rbs(30,2.0,1.0)
sample11<-rbs(30,2.2,1.0)
sample12<-rbs(30,2.4,1.0)

x1<-c(delta2bs(sample1),delta3bs(sample1))
x2<-c(delta2bs(sample2),delta3bs(sample2))
x3<-c(delta2bs(sample3),delta3bs(sample3))
x4<-c(delta2bs(sample4),delta3bs(sample4))
x5<-c(delta2bs(sample5),delta3bs(sample5))
x6<-c(delta2bs(sample6),delta3bs(sample6))
x7<-c(delta2bs(sample7),delta3bs(sample7))
x8<-c(delta2bs(sample8),delta3bs(sample8))
x9<-c(delta2bs(sample9),delta3bs(sample9))
x10<-c(delta2bs(sample10),delta3bs(sample10))
x11<-c(delta2bs(sample11),delta3bs(sample11))
x12<-c(delta2bs(sample12),delta3bs(sample12))
x<-c(x1[1],x2[1],x3[1],x4[1],x5[1],x6[1],x7[1],x8[1],x9[1],x10[1],x11[1],x12[1])
y<-c(x1[2],x2[2],x3[2],x4[2],x5[2],x6[2],x7[2],x8[2],x9[2],x10[2],x11[2],x12[2])

## Genera el gráfico
plot(x,y,xlab=expression(delta[2]),ylab=expression(delta[3]),col=4,lwd=2.0)
fitdeltabs(0.2,2)
fitdeltabs(2.4,3)
}

\keyword{robust}
\keyword{multivariate}
