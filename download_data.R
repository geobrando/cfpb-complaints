

data.path <- file.path(".","Data")

#Set the url for the data
url <- "https://files.consumerfinance.gov/ccdb/complaints.csv.zip"

#For data dictionary, go here:
#https://cfpb.github.io/api/ccdb/fields.html

#Check if the data directory exists and create it if it doesn't
if(!dir.exists(data.path)){
  dir.create(data.path)
}

data.file <- file.path(data.path, basename(url))

#Download the data to the data folder
download.file(url, destfile = data.file)


#Unzip everything
unzip(zipfile = data.file,exdir = data.path)
