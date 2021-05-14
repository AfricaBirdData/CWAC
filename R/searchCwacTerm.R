#' Search for a term in the CWAC dicctionary
#'
#' @param term A character string corresponding a term found in CWAC data. The term must be spelled exactly as it appears in the data.
#'
#' @return A list with a description of the term and, if it exists, the different values that the variable can take on.
#' @export
#'
#' @examples
#' searchCwacTerm("Season")
searchCwacTerm <- function(term){

  url <- "http://api.adu.org.za/cwac/dictionary/get"

  myfile <- RCurl::getURL(url, ssl.verifyhost = FALSE, ssl.verifypeer = FALSE)

  dict <- rjson::fromJSON(myfile)

  # Extract dictionary terms
  headerfields <- names(dict$dictionary$headerInfo)
  recordfields <- names(dict$dictionary$recordInfo)


  # Look up term in dictionary
  if(term %in% headerfields){

    dict <- dict$dictionary$headerInfo[term][[1]]

  } else if(term %in% recordfields){

    dict <- dict$dictionary$recordInfo[term][[1]]

  } else {

    stop("Term not found")

  }

  # Prepare options if they exist
  if(is.null(dict$options)){

    options <- NULL

  } else {

    options <- jsonToTibble(dict$options)

  }

  # Assemble output
  out <- list(description = dict$notes,
              options = options)


  return(out)

}