# CWAC
Code for downloading and working with CWAC data

This packages provides functionality to access and download data from the Coordinated Waterbird Counts project.

A typical workflow entails locating a site of interest, say Barberspan:
require(dplyr)
loc_code <- listCwacSites("North West") %>% filter(Name == "Barberspan") %>% pull(Loc_code)

Then, listing the cards correspoding to the site:
cards <- listCwacCards(loc_code) %>% pull(Card)

And finally, downloading the surveys correspoding to those cards:
survey <- getCwacSurvey(cards[1])

## INSTRUCTIONS TO CONTRIBUTE CODE
