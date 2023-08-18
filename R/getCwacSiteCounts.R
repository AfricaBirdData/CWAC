#' Get all CWAC counts from a site
#'
#' @param loc_code The code of a CWAC site
#'
#' @return A tibble with all the counts recorded for the desired site. Note that
#' there might be warnings about formatting.
#' @export
#'
#' @examples
#' getCwacSiteCounts(26352535)
#' getCwacSiteCounts("26352535")
getCwacSiteCounts <- function(loc_code){


  url <- paste0("https://pipeline.birdmap.africa/cwac/records/LocationCode/", loc_code, "?short=1")

  # Extract data
  myfile <- httr::RETRY("GET", url) %>%
    httr::content(as = "text", encoding = "UTF-8")

  if(myfile == ""){
    stop("We couldn't retrieve your query. Please check your spelling and try again.")
  }

  out <- rjson::fromJSON(myfile) %>%
    CWAC::jsonToTibble()

  # If there is no data for the site return an empty data frame (stored as package data)
  if(ncol(out) == 0){
    warning(paste("There seems to be no data for species", spp_code))
    out <- CWAC::cwac_count_vars
  }

  # Format rest of columns
  out <- out %>%
    dplyr::mutate(LocationCode = as.character(LocationCode),
                  LocationCodeAlias = as.character(LocationCodeAlias),
                  LocationName = as.character(LocationName),
                  Year = as.integer(Year),
                  StartDate = as.Date(StartDate),
                  NoCount = as.integer(NoCount),
                  TotalCount = as.integer(TotalCount),
                  TotalSpecies = as.integer(TotalSpecies),
                  SppRef = as.integer(SppRef),
                  Count = as.integer(Count),
                  Pairs = as.integer(Pairs),
                  X = as.numeric(X),
                  Y = as.numeric(Y))

  # Save data
  return(out)

}
