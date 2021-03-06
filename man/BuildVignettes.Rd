% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BuildVignettes.R
\name{BuildVignettes}
\alias{BuildVignettes}
\title{Build Package Vignettes}
\usage{
BuildVignettes(
  dir = getwd(),
  doc = file.path(dir, "inst/doc"),
  gs_quality = c("ebook", "printer", "screen", "none"),
  clean = TRUE,
  quiet = TRUE
)
}
\arguments{
\item{dir}{'character' string.
Path to a package's root source directory, by default the \link[=getwd]{working directory}.
Its subdirectory \sQuote{vignettes} is searched for vignette source files.}

\item{doc}{'character' string.
Path to write the vignette output files, by default \sQuote{inst/doc} under the working directory.}

\item{gs_quality}{'character' string.
Quality of compacted PDF files, the options are
\code{"ebook"} (150 dpi, default), \code{"printer"} (300 dpi),
\code{"screen"} (72 dpi), and \code{"none"} (no compression).
See \code{\link[tools]{compactPDF}} function for details.}

\item{clean}{'logical' flag.
Whether to remove all intermediate files generated by the build.}

\item{quiet}{'logical' flag.
Whether to suppress most output.}
}
\value{
Invisible \code{NULL}
}
\description{
Build package vignettes from their source files
using the \code{\link[tools]{buildVignettes}} function.
Writes the PDF and (or) HTML documents of the package vignettes,
and their executable code files.
}
\author{
J.C. Fisher, U.S. Geological Survey, Idaho Water Science Center
}
\keyword{utilities}
