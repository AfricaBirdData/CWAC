% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getCwacSiteCounts.R
\name{getCwacSiteCounts}
\alias{getCwacSiteCounts}
\title{Get all CWAC counts from a site}
\usage{
getCwacSiteCounts(loc_code)
}
\arguments{
\item{loc_code}{The code of a CWAC site}
}
\value{
A tibble with all the counts recorded for the desired site. Note that
there might be warnings about formatting.
}
\description{
Get all CWAC counts from a site
}
\examples{
getCwacSiteCounts(26352535) # Results in warning
getCwacSiteCounts("26352535")
}
