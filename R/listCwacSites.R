#' Retrieve a list of active CWAC sites registered in a South African province
#'
#' @param province A character string with the name of the province of interest. Available provinces are:
#' Northern Province, Mpumalanga, North West, Gauteng, KwaZulu-Natal, Free State, Northern Cape, Western Cape, Eastern Cape, Kenya, Angola, Tanzania, Limpopo.
#' NORTHERN PROVINCE IS ACTUALLY NOT AVAILABLE, ALTHOUGH IT SAYS IT IS ON THE WEBSITE.
#'
#' @return A tibble with a list of all active sites for the province
#' @export
#'
#' @examples
#' listCwacSites("Western Cape")
#' listCwacSites("western cape")
listCwacSites <- function(province){

  province <- stringr::str_replace(province, " ", "%20")
  province <- tolower(province)

  url <- paste0("https://pipeline.birdmap.africa/cwac/location/province/", province, "?short=1")

  myfile <- RCurl::getURL(url, ssl.verifyhost = FALSE, ssl.verifypeer = FALSE)

  out <- rjson::fromJSON(myfile) %>%
    CWAC::jsonToTibble()

  return(out)
}
