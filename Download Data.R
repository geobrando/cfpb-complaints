#Set the url for the data
url <- "https://files.consumerfinance.gov/ccdb/complaints.csv.zip"

#For data dictionary, go here:
#https://cfpb.github.io/api/ccdb/fields.html

#Check if the data directory exists and create it if it doesn't
if(!dir.exists("./Data")){
  dir.create("./Data")
}

#Download the data to the data folder
download.file(url, destfile = paste0("./Data/", basename(url)))

?getwd()

#Unzip everything
unzip(zipfile = paste0("./Data/", basename(url)), 
      exdir = "./Data")
