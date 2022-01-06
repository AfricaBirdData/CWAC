% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/addMissingCwacCounts.R
\name{addMissingCwacCounts}
\alias{addMissingCwacCounts}
\title{Add missing CWAC counts to CWAC site data}
\usage{
addMissingCwacCounts(site_counts)
}
\arguments{
\item{site_counts}{A dataframe obtained from \link[CWAC]{getCwacSiteCounts}}
}
\value{
The same site_counts dataframe provided with additional rows for
those Winter or Summer seasons for which no data were collected.
}
\description{
Add missing CWAC counts to CWAC site data
}
\examples{
counts <- getCwacSiteCounts(26352535)
counts_w_miss <- addMissingCwacCounts(counts)
}