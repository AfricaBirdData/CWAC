#' List all cards submitted for a CWAC site
#'
#' @param loc_code character string corresponding to the location code of the site of interest
#'
#' @return a tibble with a list of all cards submitted for a specific CWAC site
#' @export
#'
#' @examples
#' listCwacCards(32481810)
#' listCwacCards("32481810")
listCwacCards <- function(loc_code){

  url <- paste0("http://api.adu.org.za/cwac/site/cards/list?locationCode=", loc_code)

  myfile <- RCurl::getURL(url, ssl.verifyhost = FALSE, ssl.verifypeer = FALSE)

  jsonfile <- rjson::fromJSON(myfile)

  print(jsonfile$status$result)

  out <- jsonfile$cards %>%
    CWAC::jsonToTibble()

  # Fix column types (WE SHOULD FIX FURTHER?)
  out <- out %>%
    readr::type_convert(col_types = readr::cols(
      .default = readr::col_integer(),
      startDate = readr::col_date(format = ""),
      Season = readr::col_character(),
      TimeStart = readr::col_character(),
      TimeEnd = readr::col_character(),
      Notes = readr::col_character(),
      tstamp = readr::col_date(format = ""),
      record_status = readr::col_character(),
      Survey_notes = readr::col_logical(),
      WetLandThreat = readr::col_logical(),
      api = readr::col_character()
    ))

  return(out)

}
