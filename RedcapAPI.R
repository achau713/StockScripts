# This script includes functions to establish a connection to the REDCAP API, grab data from REDCAP
# via the REDCAP API, and to subset the datasets. 


library(REDCapR)
library(dplyr)
library(stringr)
library(tidyverse)

# ReadProjects --------------------------------------------------------------------------------


#' Read in data from Redcap project via Redcap API
#'
#' @param uri A link to redcap server
#' @param token A string granting access to a REDCAP project via the REDCAP API
#' @param fields A string or a vector of strings. Indicates desired fields to query from REDCAP project.
#' @param forms A string or a vector of strings. Indicates desired forms to query from REDCAP project.
#' @param raw_or_label A string representing whether to include raw or labelled variable values. Two options: "raw" or "label"
#    Raw variable values are usually numerically encoded. Labelled variable values are usually textually encoded. 
#' @param raw_or_label_headers A string representing whether to include raw or labelled variable names. Two options: "raw" or "label".
#    Raw variable names are intended for programming. Labelled variable names are best for creating a data dictionary. 
#' @param list_tokens A list of tokens granting accessing to multiple REDCAP projects via the REDCAP API 
#'
#' @return A data frame containing Redcap project data
#' @export
#'
#' @examples ReadProjects(token = MRABToken, raw_or_label = "label", raw_or_label_tokens = "label")
#' pregnancy_data <- map(PregnancyTokens, ~ReadProjects(token = .x, list_tokens = PregnancyTokens))
#' infant_data <- map(InfantTokens, ~ReadProjects(token = .x, list_tokens = InfantTokens))

ReadProjects <- function(uri = "https://ci-redcap.hs.uci.edu/api/", 
                         token,
                         fields = NULL,
                         forms = NULL,
                         raw_or_label = "raw",
                         raw_or_label_headers = "raw",
                         list_tokens = NULL){
  
  # Exception Handling:
  # If API request successful, then no issue.
  # If API request unsuccessful, print error message but continue running the function (when using map function)
  output <- tryCatch({
    print(paste("Project requested at:", Sys.time()))
    redcap_read_oneshot(redcap_uri = uri, 
                        token = token, 
                        fields = fields, 
                        forms = forms, 
                        raw_or_label = raw_or_label, 
                        raw_or_label_headers = raw_or_label_headers)$data
  },
  
  error = function(e){
    print(paste("There is an error: ", e))
    # Print the name of the redcap project associated with the errors
    print(paste("Unable to load dataset from:", 
                names(list_tokens)[list_tokens == token]))
  })
  return(output)
}


# ReadMetaData --------------------------------------------------------------------------------


#' Read in metadata from Redcap project via Redcap API
#'
#' @param uri A link to redcap server
#' @param token A string granting access to a REDCAP project via the REDCAP API
#' @param fields A string or a vector of strings. Indicates desired fields to query from REDCAP project.
#' @param forms A string or a vector of strings. Indicates desired forms to query from REDCAP project.
#' @param list_tokens A list of tokens granting accessing to multiple REDCAP projects via the REDCAP API 
#'
#' @return A data frame containing metadata about a Redcap project. Four columns are returned: 
#' field_name, form_name, field_label, and select_choices_or_calculations. 
#' @export
#'
#' @examples pregnancy_metadata <- map(PregnancyTokens, ~ReadMetadata(token = .x, list_tokens = PregnancyTokens))
ReadMetadata <- function(uri = "https://ci-redcap.hs.uci.edu/api/", 
                         token,
                         fields = NULL,
                         forms = NULL,
                         list_tokens = NULL){
  
  # Exception Handling:
  # If API request successful, then no issue.
  # If API request unsuccessful, print error message but continue running the function (when using map function)
  output <- tryCatch({
    print(paste("Metadata requested at:", Sys.time()))
    # use dplyr:;select() to subset specific columns from metadata
    redcap_metadata_read(
      redcap_uri = uri,
      token = token,
      fields = fields,
      forms = forms)$data  %>% 
      select(field_name, form_name, field_label, select_choices_or_calculations)
  },
  
  error = function(e){
    print(paste("There is an error: ", e))
    # Print the name of the redcap project associated with the errors
    print(paste("Unable to load data dictionary from:", 
                names(list_tokens)[list_tokens == token]))
  })
  return(output)
}
