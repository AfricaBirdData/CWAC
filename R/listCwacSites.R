#' Retrieve a list of active CWAC sites registered in a South African province
#'
#' @param .region_type The type of region we are interested on.
#' Two options: "country" and "province".
#' @param .region A character string corresponding to the specific region we are
#' interested in. It can be either a country in Southern Africa, or a South African
#' province.
#'
#' @return A tibble with a list of all active sites for the province
#' @export
#'
#' @examples
#' listCwacSites(.region_type = "province", .region = "Western Cape")
#' listCwacSites(.region_type = "country", .region = "Kenya")
listCwacSites <- function(.region_type = c("country", "province"),
                          .region){

  .region_type <- match.arg(.region_type, c("country", "province"))

  .region <- stringr::str_replace(.region, " ", "%20") %>%
    tolower()

  url <- paste0("https://pipeline.birdmap.africa/cwac/location/", .region_type, "/", .region, "?short=1")

  myfile <- httr::RETRY("GET", url) %>%
    httr::content(as = "text", encoding = "UTF-8")

  if(myfile == ""){
    stop("We couldn't retrieve your query. Please check your spelling and try again.")
  }

  out <- rjson::fromJSON(myfile) %>%
    CWAC::jsonToTibble()

  # Format
  out <- out %>%
    readr::type_convert(col_types = readr::cols()) %>%
    suppressMessages()

  return(out)
}
