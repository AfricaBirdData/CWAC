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

For site owners:

There is the danger of multiple people working simultaneously on the project code. If you make changes locally on your computer and, before you push your changes, others push theirs, there might be conflicts. This is because the HEAD pointer in the main branch has moved since you started working. 

To deal with these lurking issues, I would suggest opening and working on a topic branch. This is a just a regular branch that has a short lifespan. In steps:

- Open a branch at your local machine
- Push to the remote repo
- Make your changes in your local machine
- Commit and push to remote
- In the GitHub repo you will now see an option that notifies of changes in a branch: compare and pull request.
- Close/delete the branch.

Opening branches is quick and easy, so there is no harm in opening multiple branches a day. However, it is important to merge and delete them often to keep things tidy. Git provides functionality to deal with conflicting branches. More about branches here:

https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell

Another idea is to use the 'issues' tab that you find in the project header. There, we can identify issues with the package, assign tasks and warn other contributors that we will be working on the code.
