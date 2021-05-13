#' Helper function to transform a JSON object to a tibble
#'
#' @param jsonfile An object obtained when a JSON file is downloaded
#'
#' @return A tibble
#' @export
#' @examples
#' url <- "http://api.adu.org.za/cwac/sites/list?province=north20%west"
#' myfile <- RCurl::getURL(url, ssl.verifyhost = FALSE, ssl.verifypeer = FALSE)
#' jsonfile <- rjson::fromJSON(myfile)
#' jsonToTibble(jsonfile)
jsonToTibble <- function(jsonfile){

  out <- jsonfile %>%
    lapply(function(x) {
      x[sapply(x, is.null)] <- NA
      unlist(x)
    }) %>%
    do.call("rbind", .) %>%
    dplyr::as_tibble()

  return(out)

}
