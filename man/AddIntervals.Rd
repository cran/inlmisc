% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AddIntervals.R
\name{AddIntervals}
\alias{AddIntervals}
\title{Add Interval Symbols to Plot}
\usage{
AddIntervals(
  x,
  y0,
  y1,
  hin = NULL,
  col = "black",
  lty = 1,
  lwd = 0.7,
  cex = 1,
  xpd = FALSE,
  ...,
  nondetects = NULL
)
}
\arguments{
\item{x}{'numeric' or 'Date' vector.
\emph{x} coordinate of interval symbols.}

\item{y0}{'numeric' vector.
\emph{y} coordinate of points from which to draw.}

\item{y1}{'numeric' vector.
\emph{y} coordinate of points to which to draw.}

\item{hin}{'numeric' number.
Horizontal length of an interval head, in inches.}

\item{col, lty, lwd, cex, xpd}{graphical parameters; see \code{\link[graphics]{par}} for details.
\code{NA} values in \code{col} cause the interval to be omitted.}

\item{...}{Additional graphical parameters to the \code{\link[graphics]{points}} function.}

\item{nondetects}{'list'.
Overrides graphical parameters used for left- and right-censored data.
Passed arguments include \code{col}, \code{lty}, and \code{lwd}.}
}
\value{
Invisible \code{NULL}
}
\description{
Add interval symbols (also known as error bars) to plots.
}
\details{
For each observation \code{i}, the data type is identified using
    \code{(y0[i], Inf)} for right-censored,
    \code{y0[i] = y1[i]} for exact, and
    \code{(-Inf, y1[i])} for left-censored, and
    \code{(y0[i], y1[i])} for interval-censored.
  Where infinity may be represented with either \code{Inf} or \code{NA}.
}
\examples{
set.seed(1)
x <- stats::runif(12)
y <- stats::rnorm(12)
plot(x, y)
dy <- sort.int(y) / 5
AddIntervals(x, y - dy, y + dy, col = "red", xpd = TRUE)

n <- 50
x <- sort.int(stats::runif(n, max = 100))
y1 <- y0 <- stats::runif(n, max = 100)
y1[sample.int(n, 5)] <- stats::runif(5, max = 100)
y0[sample.int(n, 5)] <- -Inf
y1[sample.int(n, 5)] <-  Inf
ylim <- range(pretty(c(y0, y1)))
plot(NA, xlim = range(x), ylim = ylim, xlab = "x", ylab = "y")
AddIntervals(x, y0, y1, col = "blue", xpd = TRUE,
             nondetects = list("col" = "red", "lty" = 2))
print(cbind(x, y0, y1))

}
\author{
J.C. Fisher, U.S. Geological Survey, Idaho Water Science Center
}
\keyword{hplot}
