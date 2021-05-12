getCwacSurvey <- function(card_code){

  url <- paste0("http://api.adu.org.za/cwac/cards/single/get?card=", card_code)

  myfile <- RCurl::getURL(url, ssl.verifyhost = FALSE, ssl.verifypeer = FALSE)
  jsonfile <- rjson::fromJSON(myfile)

  print(jsonfile$status$result)

  # Extract and prepare summary

  summary <- do.call("cbind", jsonfile$header) %>%
    dplyr::as_tibble() %>%
    readr::type_convert(col_types = readr::cols(
      ID = readr::col_integer(),
      Card = readr::col_integer(),
      Loc_Code = readr::col_integer(),
      startDate = readr::col_date(format = ""),
      Season = readr::col_character(),
      TimeStart = readr::col_time(format = ""),
      TimeEnd = readr::col_time(format = ""),
      Compiler = readr::col_integer(),
      CountType = readr::col_integer(),
      Shoreline = readr::col_integer(),
      OpenWater = readr::col_integer(),
      WetlandCondition = readr::col_integer(),
      CountCondition = readr::col_integer(),
      TotalCount = readr::col_integer(),
      TotalSpecies = readr::col_integer(),
      Notes = readr::col_character(),
      tstamp = readr::col_date(format = ""),
      NoCount = readr::col_integer(),
      api = readr::col_character()
    ))

  # Extract and prepare observers

  observers <- jsonfile$observers

  observers <- do.call("rbind", lapply(observers, function(x) do.call("cbind", x))) %>%
    dplyr::as_tibble()


  # Extract and prepare records

  records <- jsonfile$records %>%
    lapply(function(x) {
      x[sapply(x, is.null)] <- NA
      unlist(x)
    }) %>%
    do.call("rbind", .) %>%
    dplyr::as_tibble() %>%
    readr::type_convert(col_types = readr::cols(
      count_id = readr::col_integer(),
      card = readr::col_integer(),
      spp = readr::col_integer(),
      count = readr::col_integer(),
      breeding = readr::col_integer(),
      pairs = readr::col_double(),
      api = readr::col_character(),
      taxon.order = readr::col_character(),
      taxon.Family = readr::col_character(),
      taxon.Genus = readr::col_character(),
      taxon.Species = readr::col_character(),
      taxon.Common_group = readr::col_character(),
      taxon.Common_species = readr::col_character(),
      taxon.iucn_status = readr::col_character()
    ))

  out <- list(summary = summary,
              observers = observers,
              records = records)

  return(out)

}
