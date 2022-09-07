#' Retrives available metadata for a CWAC site
#'
#' @param loc_code Numeric or character string corresponding to a CWAC site code
#'
#' @return A tibble with metadata for a specific CWAC site
#' @export
#'
#' @examples
#' getCwacSiteInfo(23312919)
#' getCwacSiteInfo("23312919")
getCwacSiteInfo <- function(loc_code){

  url <- paste0("http://api.adu.org.za/cwac/site/information/get?locationCode=", loc_code)

  myfile <- httr::RETRY("GET", url) %>%
    httr::content(as = "text", encoding = "UTF-8")

  if(myfile == ""){
    stop("We couldn't retrieve your query. Please check your spelling and try again.")
  }

  jsonfile <- rjson::fromJSON(myfile)

  jsonout <- jsonfile$status

  # print(jsonout$result)

  out <- jsonfile$site %>%
    CWAC::jsonToTibble()

  return(out)

}
