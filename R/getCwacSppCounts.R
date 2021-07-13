#' Get all CWAC counts for a species
#'
#' @param spp_code The CWAC code of a species
#'
#' @return A tibble with all the counts recorded for the desired species.
#' Note that there might be warnings about formatting.
#' @export
#'
#' @examples
#' getCwacSppCounts(41)
#' getCwacSppCounts("41")
getCwacSppCounts <- function(sp_code){

  url <- paste0("https://pipeline.birdmap.africa/cwac/records/SppRef/", sp_code, "?short=1")

  myfile <- RCurl::getURL(url, ssl.verifyhost = FALSE, ssl.verifypeer = FALSE)

  out <- rjson::fromJSON(myfile) %>%
    CWAC::jsonToTibble()

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
