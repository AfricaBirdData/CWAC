#' Get CWAC species list
#'
#' @return A dataframe with a list of all species recorded in the CWAC project
#' @export
#'
#' @examples
#' listCwacSpp()
listCwacSpp <- function(){

  url <- paste0("https://pipeline.birdmap.africa/cwac/species/?short=1")

  myfile <- httr::RETRY("GET", url) %>%
    httr::content(as = "text", encoding = "UTF-8")

  if(myfile == ""){
    stop("We couldn't retrieve your query. Please check your spelling and try again.")
  }

  out <- rjson::fromJSON(myfile) %>%
    CWAC::jsonToTibble()

  # Format
  out <- out %>%
    readr::type_convert(col_types = readr::cols(
      .default = readr::col_character(),
      Ramsar_1_Level = readr::col_integer(),
      GlobalIBA_1_Level = readr::col_integer(),
      SubRegional_IBA_05_Level = readr::col_integer()
    ))

  out <- out[out$SppRef != "0",]

  # Save data
  return(out)

}
