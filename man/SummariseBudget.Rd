% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SummariseBudget.R
\name{SummariseBudget}
\alias{SummariseBudget}
\title{Summarize MODFLOW Water Budget}
\usage{
SummariseBudget(budget, desc = NULL, id = NULL)
}
\arguments{
\item{budget}{'character' string or 'list'.
Either the path to a MODFLOW cell-by-cell budget file or
the object returned from the \code{\link{ReadModflowBinary}} function.}

\item{desc}{'character' vector.
Data-type descriptors, such as \code{c("wells", "drains")}.
If missing, all data types are summarized.}

\item{id}{'character' string.
Name of auxiliary variable, a variable of additional values associated with each cell
saved using the \emph{\bold{"AUXILIARY"}} output option.}
}
\value{
A 'data.table' with the following variables:
  \describe{
    \item{desc}{description of data type, such as "wells".}
    \item{kper}{stress period}
    \item{kstp}{time step}
    \item{id}{auxiliary variable name}
    \item{delt}{length of the current time step.}
    \item{pertim}{time in the stress period.}
    \item{totim}{total elapsed time}
    \item{count}{number of cells in each subset.}
    \item{flow.sum}{total volumetric flow rate}
    \item{flow.mean}{mean volumetric flow rate}
    \item{flow.median}{median volumetric flow rate}
    \item{flow.sd}{standard deviation of volumetric flow rate.}
    \item{flow.dir}{flow direction where "in" and "out" indicate
      water entering and leaving the groundwater system, respectively.}
  }
}
\description{
Summarize \href{https://www.usgs.gov/mission-areas/water-resources/science/modflow-and-related-programs}{MODFLOW}
volumetric flow rates by boundary condition types.
Cell-by-cell flow data is split into subsets,
summary statistics computed for each subset, and a summary table returned.
}
\details{
Subsets are grouped by data type (desc), stress period
  (kper), time step (kstp), and optional auxiliary variable.
  Data in the MODFLOW cell-by-cell budget file must be saved using the
  \emph{\bold{"COMPACT BUDGET"}} output option.
}
\examples{
path <- system.file("extdata", "ex.bud", package = "inlmisc")
out <- SummariseBudget(path, desc = "river leakage", id = "iface")
print(out)

}
\seealso{
\code{\link{ReadModflowBinary}}
}
\author{
J.C. Fisher, U.S. Geological Survey, Idaho Water Science Center
}
\keyword{utilities}
