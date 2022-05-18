#' Add missing CWAC counts to CWAC site data
#'
#' @param site_counts A dataframe obtained from \link[CWAC]{getCwacSiteCounts}
#' @param years A vector of years the function should complete. This is useful
#' for cases where counts are missing at the beginning or end of the period. We
#' can explicitly state which years should be in the data.
#'
#' @return The same site_counts dataframe provided with additional rows for
#' those Winter or Summer seasons for which no data were collected.
#' @export
#'
#' @examples
#' counts <- getCwacSiteCounts(26352535)
#' counts_w_miss <- addMissingCwacCounts(counts, years = 1993:2020)
addMissingCwacCounts <- function(site_counts, years){

    # Some records are classified as "O" (other). We are only interested in summer and winter
    # so we filter out "O" and sum all counts per card
    counts_all_spp <- site_counts %>%
        dplyr::filter(Season != "O",
                      Year %in% years) %>%
        dplyr::group_by(LocationCode, X, Y, Card, Year, Season) %>%
        dplyr::summarize(count = sum(Count)) %>%
        dplyr::ungroup() %>%
        tidyr::complete(Year = years, Season = c("S", "W"), LocationCode, X, Y) # Fill in missing years

    # Separate missing counts
    missing <- counts_all_spp %>%
        dplyr::filter(is.na(count))

    # Append to original dataframe
    missing[dplyr::setdiff(names(site_counts), names(missing))] <- NA
    site_counts <- site_counts %>%
        rbind(missing %>%
                  dplyr::select(names(site_counts)))

    if(dplyr::n_distinct(site_counts[,c("LocationCode", "X", "Y")]) != 1){
        warning("Counts for more than one site OR same site with different coordinates detected")
    }

    return(site_counts)

}
