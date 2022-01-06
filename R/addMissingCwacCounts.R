#' Add missing CWAC counts to CWAC site data
#'
#' @param site_counts A dataframe obtained from \link[CWAC]{getCwacSiteCounts}
#'
#' @return The same site_counts dataframe provided with additional rows for
#' those Winter or Summer seasons for which no data were collected.
#' @export
#'
#' @examples
#' counts <- getCwacSiteCounts(26352535)
#' counts_w_miss <- addMissingCwacCounts(counts)
addMissingCwacCounts <- function(site_counts){

    # Some records are classified as "O" (other). We are only interested in summer and winter
    # so we filter out "O" and sum all counts per card
    counts_all_spp <- site_counts %>%
        dplyr::filter(Season != "O") %>%
        dplyr::group_by(Card, Year, Season) %>%
        dplyr::summarize(count = sum(Count)) %>%
        dplyr::ungroup() %>%
        tidyr::complete(Year = min(Year):max(Year), Season) # Fill in missing years

    # Separate missing counts
    missing <- counts_all_spp %>%
        dplyr::filter(is.na(count))

    # Append to original dataframe
    missing[dplyr::setdiff(names(site_counts), names(missing))] <- NA
    site_counts <- site_counts %>%
        rbind(missing %>%
                  dplyr::select(names(site_counts)))

    return(site_counts)

}
