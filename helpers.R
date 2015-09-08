# extract a date from a filename
get.kbdi.date <- function(filename)
{
  filename.base <- gsub(".csv", "", filename)
  date.str <- unlist(strsplit(filename.base, "-"))[3]
  date.str <- add.dashes(date.str)  
}

# add dashes to a date that's currently in the format "YYYYMMDD"
add.dashes <- function(date.str)
{
  year <- substr(date.str, 1, 4) 
  month <- substr(date.str, 5, 6)
  date <- substr(date.str, 7, 8)
  
  output <- paste(c(year, month, date), collapse="-")
  
  return(output)
}

# rename and re-order columns
cleanup.kbdi.cols <- function(df)
{
  
  # rename columns
  colnames(df) <- c("geocode",
                    "mean_kbdi",
                    "kbdi_change",
                    "pct_kbdi_0_100",
                    "pct_kbdi_100_200",
                    "pct_kbdi_200_300",
                    "pct_kbdi_300_400",
                    "pct_kbdi_400_500",
                    "pct_kbdi_500_600",
                    "pct_kbdi_600_700",
                    "pct_kbdi_700_800",
                    "min_kbdi",
                    "max_kbdi",
                    "date")
  
  # re-order columns to put min/max next to mean/change
  df <- df[, c("date", "geocode", "mean_kbdi", "kbdi_change", "min_kbdi", "max_kbdi",
                                   "pct_kbdi_0_100", "pct_kbdi_100_200", "pct_kbdi_200_300",
                                   "pct_kbdi_300_400", "pct_kbdi_400_500", "pct_kbdi_500_600",
                                   "pct_kbdi_600_700", "pct_kbdi_700_800")]
  
  return(df)
  
}

# split the "Min/Max" column into two columns
split.min.max <- function(df)
{
  # split "Min/Max" column into two columns
  min.max <- unlist(strsplit(as.character(df[, "Min.Max"]), "/"))
  min.max <- as.numeric(min.max)
  df[,"Min"] <- min.max[1]
  df[,"Max"] <- min.max[2]
  df[,"Min.Max"] <- NULL
  
  return(df)
}

# extract the statewide information from the daily report
get.statewide.df <- function(date.df, date)
{
  statewide.row <- which(date.df[,1] == "Statewide")
  statewide.df <- date.df[statewide.row,]
  statewide.df <- split.min.max(statewide.df)  
  statewide.df[,"Date"] <- date    
  statewide.df <- cleanup.kbdi.cols(statewide.df)
  
  return(statewide.df)
}

# helper function to check if all values in a given row of a data frame are valid
# i.e., check that none of them are equal to NA
all.valid <- function(row) {
  all(sapply(row, function(x) !is.na(x)))
}

# extract the district-level information from the daily report
get.districts.df <- function(date.df, date)
{
  districts.row <- which(date.df[,1] == "Districts")
  counties.row <- which(date.df[,1] == "Counties")
  
  # data is mal-formed for this date
  if (length(districts.row) == 0 || length(counties.row) == 0) {
    warning(paste0("Data is mal-formed for date ", date, ". Not appending any district data for this date."))
    return(NULL)
  }
  
  districts.df <- date.df[(districts.row + 1) : (counties.row - 1),]
  non.empty.rows <- which(apply(districts.df, 1, all.valid))
  districts.df <- districts.df[non.empty.rows,]
  districts.df <- split.min.max(districts.df)
  districts.df[,"Date"] <- rep(date, nrow(districts.df))
  districts.df <- cleanup.kbdi.cols(districts.df)
  
  return(districts.df)
}

# extract the county-level information from the daily report
get.counties.df <- function(date.df, date)
{
  counties.row <- which(date.df[,1] == "Counties")
  
  if(length(counties.row) == 0) {
    warning("Data is mal-formed for date ", date, ". Not appending any county data for this date.")
    return(NULL)
  }
  
  counties.df <- date.df[counties.row : nrow(date.df),]
  non.empty.rows <- which(apply(counties.df, 1, all.valid))
  counties.df <- counties.df[non.empty.rows,]
  counties.df <- split.min.max(counties.df)
  counties.df[,"Date"] <- rep(date, nrow(counties.df))
  counties.df <- cleanup.kbdi.cols(counties.df)
  
  return(counties.df)
  
}

# helper function to handle empty files without the script stopping
safely.read.data <- function(filename)
{
  output <- tryCatch({
      read.csv(filename)
    }, error = function(e) {
      print(e)
      print(paste0("Filename: ", filename))
      print("Continuing...")
      return(NULL)
    })
  
  return(output)
}