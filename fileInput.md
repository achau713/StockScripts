File Input in R
================

Sometimes you will need to import a bunch of files into R. We don’t want
to do this manually, listing the path to each file. Instead, we can use
tools in R to vectorize this process.

# Setup and workflow

I highly recommend implementing R Studio projects into your workflow. By
using R Studio projects, you contain individual projects within a single
working directory. That way, you will not get mixed up when working on
different projects simulteanously. Every time you start working on a
project, open up the .Rproj file that R creates for you when you first
create a new project. By doing this, a new instance of R Studio will
load up with your the working directory associated with your R project.

In addition to R Studio projects, using the *here* library will help you
navigate your files and directories easily from your project directory.
The *here* library allows you to construct paths to your files and
sub-directories by augmenting the path root. More on this below

``` r
# your path root
here::here()
```

    ## [1] "C:/Users/Anthony Chau/Documents/StockScripts"

Suppose we create a new directory called “data” and then a sub-directory
inside “data” called “raw”. Then, imagine we had 25 csv files in “raw”.
In other words, we have:

  - \~/data/raw/data1.csv
  - …
  - …
  - \~/data/raw/data25.csv

We can use a vectorized approach along with the here package to read in
all 25 files.

``` r
# Get full file paths to each csv files
csvFilePaths <- list.files(here("data", "raw"), full.names = TRUE)

# Get name of each file (without the extension)

# basename() removes all of the path up to and including the last path seperator
# file_path_sands_ext() removes the .csv extension

csvFileNames <- tools::file_path_sans_ext(basename(csvFilePaths))


# Now, read in all the files

# note csvData is a list of data frames
csvData <- purrr::map(csvFilePaths, ~ readr::read_csv(file = .x))

# assign names to each element in csvData
names(csvData) <- csvFileNames
```

Now, you can read in any number of files without the hassle of manually
specifying file paths\!

Hope this helps\! Please comment on what other tips and tricks in R you
would like to see.
