#' Get all CWAC counts for a species
#'
#' @param spp_code The CWAC code of a species. Only a single species is accepted
#' at the moment.
#'
#' @return A tibble with all the counts recorded for the desired species.
#' Note that there might be warnings about formatting.
#' @export
#'
#' @examples
#' getCwacSppCounts(41)
#' getCwacSppCounts("41")
getCwacSppCounts <- function(spp_code){

  url <- paste0("https://pipeline.birdmap.africa/cwac/records/SppRef/", spp_code, "?short=1")

  myfile <- httr::RETRY("GET", url) %>%
    httr::content(as = "text", encoding = "UTF-8")

  if(myfile == ""){
    stop("We couldn't retrieve your query. Please check your spelling and try again.")
  }

  out <- rjson::fromJSON(myfile) %>%
    CWAC::jsonToTibble()

  # If there is no data for the species return an empty data frame (stored as package data)
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
