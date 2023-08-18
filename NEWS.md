# CWAC 0.1.4

* Changed column specification of dataframes. There were problems with trailing
zeros in some codes such as `LocationCode` and dates, so we are now more conservative
and favour character variables.

# CWAC 0.1.3

* Return empty data frame, with informative warning, when no CWAC data for a site.

* Site location codes are returned as characters to avoid losing trailing zeros.

# CWAC 0.1.2

* Return empty data frame, with informative warning, when no CWAC data for a species.

# CWAC 0.1.1

* Removed unnecessary dependencies: data.table, lubridate, utils

* Fixed arguments with multiple set options

# CWAC 0.1.0

* First package release

# CWAC 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
