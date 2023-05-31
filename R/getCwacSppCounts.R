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
    return(CWAC::cwac_count_vars)
  }

  # Format
  out <- out %>%
    dplyr::mutate(TimeStart = substr(TimeStart, 1, 5),
                  TimeEnd = substr(TimeEnd, 1, 5),
                  TimeStart = gsub("\\.", ":", TimeStart),
                  TimeEnd = gsub("\\.", ":", TimeEnd)) %>%
    readr::type_convert(col_types = readr::cols(
      .default = readr::col_integer(),
      LocationName = readr::col_character(),
      Province = readr::col_character(),
      Country = readr::col_character(),
      StartDate = readr::col_date(format = ""),
      Season = readr::col_character(),
      TimeStart = readr::col_time(format = ""),
      TimeEnd = readr::col_time(format = ""),
      WetlandThreat = readr::col_logical(),
      Notes = readr::col_character(),
      record_status = readr::col_character(),
      Survey_notes = readr::col_logical(),
      WetIntCode = readr::col_character(),
      Odr = readr::col_character(),
      Family = readr::col_character(),
      Genus = readr::col_character(),
      Species = readr::col_character(),
      Common_group = readr::col_character(),
      Common_species = readr::col_character(),
      Y = readr::col_double(),
      X = readr::col_double()
    ))

  # Save data
  return(out)

}
