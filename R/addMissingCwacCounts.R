#' Add missing CWAC counts to CWAC site data
#'
#' @param site_counts A dataframe obtained from \link[CWAC]{getCwacSiteCounts}
#' @param years A vector of years the function should complete. This is useful
#' for cases where counts are missing at the beginning or end of the period. We
#' can explicitly state which years should be in the data.
#'
#' @return The same site_counts dataframe provided with additional rows for
#' those Winter or Summer seasons for which no data were collected.
#' @details Note that this function only works for South Africa currently. This
#' is because it assumes that there are only two seasons: summer (labelled "S") and
#' winter (labelled "W"). If any of these seasons have no data for any given
#' year the function will fill it in with an NA.
#' @export
#'
#' @examples
#' counts <- getCwacSiteCounts("26352535")
#' counts_w_miss <- addMissingCwacCounts(counts, years = 1993:2020)
addMissingCwacCounts <- function(site_counts, years){

  if(length(unique(site_counts$LocationCode)) > 1){
    stop("There is more than one CWAC location in the data. Please, process one location at a time.")
  }

  if(unique(site_counts$Country) != "South Africa"){
    stop("This function currently only takes count data from South African sites. See details in ?addMissingCwacCounts")
  }

  # Subset data to the years of interest
  site_counts <- site_counts %>%
    dplyr::filter(Year %in% years)

  # Some records are classified as "O" (other). We are only interested in summer and winter
  # so we filter out anything else and sum all counts per card
  counts_w_miss <- site_counts %>%
    dplyr::mutate(present = 1) %>%  # Aux variable to identify new records
    dplyr::filter(Season %in% c("S", "W")) %>%
    dplyr::group_by(LocationCode, X, Y, Card, StartDate, Year, Season, present) %>%
    dplyr::summarize(count = sum(Count),
                     present = sum(present)) %>%
    dplyr::ungroup() %>%
    tidyr::complete(Year = years, Season = c("S", "W"), LocationCode, X, Y) # Fill in missing years

  # Separate missing counts
  missing <- counts_w_miss %>%
    dplyr::filter(is.na(present)) %>%
    dplyr::select(-present)

  # Append to original dataframe
  missing[dplyr::setdiff(names(site_counts), names(missing))] <- NA

  site_counts <- site_counts %>%
    rbind(missing %>%
            dplyr::select(names(site_counts))) %>%
    dplyr::arrange(Year, Season, StartDate)

  if(dplyr::n_distinct(site_counts[,c("LocationCode", "X", "Y")]) != 1){
    warning("Counts with different coordinates detected. Review output.")
  }

  return(site_counts)

}
