# This script includes functions to establish a connection to the REDCAP API, grab data from REDCAP
# via the REDCAP API, and to subset the datasets. 


library(REDCapR)
library(dplyr)
library(stringr)
library(tidyverse)

# ReadProjects --------------------------------------------------------------------------------


ReadProjects <- function(uri, 
                         token,
                         fields = NULL,
                         forms = NULL,
                         raw_or_label = "raw",
                         raw_or_label_headers = "raw",
                         list_tokens = NULL){
  
  # This function reads in REDCAP project into R. By default, the function reads in the entire dataset from REDCAP. 
  
  # By default, ReadProjects() retrieves data with raw variable names and raw values. 
  
  # We can specific desired fields and forms by providing a string or a vector of strings to the fields and forms arguments.
  
  # Input:
  # 1. uri: a link to the API
  # 2. token: a string granting access to a REDCAP project via the REDCAP API
  # 3. fields: a string or a vector of strings. Indicates desired fields to query from REDCAP project. 
  # 4. forms: a string or a vector of strings. Indicates desired forms to query from REDCAP project.
  # 5. raw_or_label: a string representing whether to include raw or labelled variable values. Two options: "raw" or "label"
  #    Raw variable values are usually numerically encoded. Labelled variable values are usually textually encoded.
  # 6. raw_or_label_headers: a string representing whether to include raw or labelled variable names. Two options: "raw" or "label".
  #    Raw variable names are intended for programming. Labelled variable names are best for creating a data dictionary.
  # 7. list_tokens: a list of tokens granting accessing to multiple REDCAP projects via the REDCAP API
  
  # Output: a data frame consisting of variables from a REDCAP project. 
  
  #####################################################################
  
  # Example function calls:
  
  # ReadProjects(uri = "https://COMPANY.COM/API",
  #              token = "AADUISAN09FS",
  #              fields = c("ID", "RACE", "INCOME"),
  #              forms = "2019Data")
  
  #####################################################################

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
    # Print the dataset assocated with the errors
    print(paste("Unable to load dataset from:", 
                names(list_tokens)[list_tokens == token]))
  }
  )
  return(output)
}

# ReadMetaData --------------------------------------------------------------------------------


# function reads in metadata from one REDCap Project
ReadMetadata <- function(uri = "https://ci-redcap.hs.uci.edu/api/", 
                         token,
                         fields = NULL,
                         forms = NULL,
                         list_tokens = NULL){
  
  # This function reads in the metadata from a REDCAP project via the REDCAP API.
  
  # Input:
  # 1. uri: a link to the API
  # 2. token: a string granting access to a REDCAP project via the REDCAP API
  # 3. fields: a string or a vector of strings. Indicates desired fields to query from REDCAP project. 
  # 4. forms: a string or a vector of strings. Indicates desired forms to query from REDCAP project.
  # 5. list_tokens: a list of tokens granting accessing to multiple REDCAP projects via the REDCAP API
  
  #####################################################################
  
  # Output: a data frame containing the metadata for a REDCAP project. The data frame will contain 4 columns:
  # field_name, form_name, field_label, and select_choices_or_calculations. 
  
  #####################################################################
  
  # Example function calls:
  
  # ReadMetaData(uri = "https://COMPANY.COM/API",
  #              token = "AADUISAN09FS",
  #              fields = c("ID", "INSULIN_LEVEL", "BP_READING"),
  #              forms = "2019Data")
  
  
  # Exception Handling:
  # If API request successful, then no issue.
  # If API request unsuccessful, print error message but continue running the function (when using map function)
  output <- tryCatch({
    print(paste("Metadata requested at:", Sys.time()))
    redcap_metadata_read(redcap_uri = uri,
                         token = token,
                         fields = fields,
                         forms = forms)$data  %>% 
                         # subset specific columns from metadata
                         select(field_name, form_name, field_label, select_choices_or_calculations)
  },
  
  error = function(e){
    print(paste("There is an error: ", e))
    # Print the dataset assocated with the errors
    print(paste("Unable to load data dictionary from:", 
                names(list_tokens)[list_tokens == token]))
  }
  )
  return(output)
}


