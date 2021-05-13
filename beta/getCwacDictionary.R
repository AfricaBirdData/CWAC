#' Downloads the list of terms used in CWAC
#'
#' @return A list with three objects: i) A description of terms used in CWAC, ii) a species list and iii) the different possible breeding status.
#' @export
#'
#' @examples
#' getCwacDictionary()
getCwacDictionary <- function(){

  url <- "http://api.adu.org.za/cwac/dictionary/get"

  myfile <- RCurl::getURL(url, ssl.verifyhost = FALSE, ssl.verifypeer = FALSE)

  rawout <- rjson::fromJSON(myfile)

  # Extract species list
  spplist <- rawout$dictionary$recordInfo$SpeciesList$options %>%
    CWAC::jsonToTibble()

  # Extract breeding options
  breedopt <- rawout$dictionary$recordInfo$BreedingOptions$options %>%
    CWAC::jsonToTibble()


  # HEADER OPTIONS ARE MISSING!!!
  recordoptions <- lapply(rawout$dictionary$headerInfo, "[[", "options")


  # Others
  headerfields <- names(rawout$dictionary$headerInfo)
  headerdescription <- lapply(rawout$dictionary$headerInfo, "[[", "notes")
  recordfields <- names(rawout$dictionary$recordInfo)
  recorddescription <- lapply(rawout$dictionary$recordInfo, "[[", "notes")

  description <- dplyr::tibble(field = c(unlist(headerfields), unlist(recordfields)),
                               description = c(unlist(headerdescription), unlist(recorddescription)))

  # Format output
  out <- list(description = description,
              spp_list = spplist,
              breed_opt = breedopt)

  return(out)

}
