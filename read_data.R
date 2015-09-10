source("helpers.R")

### Initialize constants, data frames, etc.

proj.root <- getwd()
kbdi.dir <- paste0(proj.root, "/data/kbdi/")

## TO-DO: figure out what "-comp" filenames are and how to handle them
kbdi.filenames <- dir(kbdi.dir, pattern = "kbdi-report-[0-9]+\\.csv")

statewide.df <- data.frame()
districts.df <- data.frame()
counties.df <- data.frame()

print(paste0("Processing daily data..."))
      
### For every file in the kbdi raw files, break it up into
### statewide data, district data, and county data

for (filename in kbdi.filenames) {
  date <- get.kbdi.date(filename)
  date.file <- paste(c(kbdi.dir, filename), collapse="")
  
  date.data <- safely.read.data(date.file)
  if (is.null(date.data)) {
    next
  }  
  
  # break up day's report into three: statewide, districts, and counties
  statewide.date.df <- get.statewide.df(date.data, date)
  districts.date.df <- get.districts.df(date.data, date)
  counties.date.df <- get.counties.df(date.data, date)

  # append each of the three dfs to its respective cumulative df
  statewide.df <- rbind(statewide.df, statewide.date.df)
  if (!is.null(districts.date.df)) {
    districts.df <- rbind(districts.df, districts.date.df)
  }
  if (!is.null(counties.date.df)) {
    counties.df <- rbind(counties.df, counties.date.df)
  }
}

### Write each aggregated data frame to its own .csv

print("Writing data to .csv files...")

write.csv(statewide.df, paste0(kbdi.dir, "/statewide_kbdi.csv"), row.names = FALSE)
write.csv(districts.df, paste0(kbdi.dir, "/districts_kbdi.csv"), row.names = FALSE)
write.csv(counties.df, paste0(kbdi.dir, "/counties_kbdi.csv"), row.names = FALSE)

print("Done.")