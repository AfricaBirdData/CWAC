#' Retrieve a list of active CWAC sites registered in a South African province
#'
#' @param .region_type The type of region we are interested on.
#' Three options: "country", "province" and "pentad".
#' @param .region A character string corresponding to the specific region we are
#' interested in. It can be either a country in Southern Africa, a South African
#' province or a pentad code.
#'
#' @return A tibble with a list of all active sites for the province
#' @export
#'
#' @examples
#' listCwacSites(.region_type = "province", .region = "Western Cape")
#' listCwacSites(.region_type = "country", .region = "Kenya")
listCwacSites <- function(.region_type = c("country", "province", "pentad"),
                          .region){

  if(is.null(.region_type)){
    .region_type <- "country"
  } else if(!.region_type %in% c("country", "province", "pentad")){
    stop(".region_type must be one of 'country', 'province', 'pentad'")
  }

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

  return(out)
}
