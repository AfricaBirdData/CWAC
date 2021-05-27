#' Get all CWAC counts from a site
#'
#' @param loc_code The code of a CWAC site
#'
#' @return A tibble with all the counts recorded for the desired site
#' @export
#'
#' @examples
#' getCwacSiteCounts(26352535)
#' getCwacSiteCounts("26352535")
getCwacSiteCounts <- function(loc_code){

  # Extract location cards
  cards <- CWAC::listCwacCards(loc_code)

  # Download surveys based on location cards
  invisible(utils::capture.output(surveys <- lapply(cards$Card, CWAC::getCwacSurvey)))


  # Join counts with survey metadata ----------------------------------------

  # Extract counts
  counts <- lapply(surveys, "[[", "records")

  # Check that all surveys have the same fields
  if(CWAC::checkListEqual(lapply(counts, names))){

     # If TRUE bind data frame
    counts <- do.call("rbind", counts)

  } else {

    stop("Count data frames have different fields, when they shouldn't.")

  }

  # Extract survey metadata
  info <- lapply(surveys, "[[", "summary")

  # Use data.table to bind dataframes with different fields
  info <- data.table::rbindlist(info, fill = TRUE)

  # Combine data and info
  counts <- dplyr::full_join(counts, info, by = c("card" = "Card"))

  # Save data ---------------------------------------------------------------

  return(counts)

}
