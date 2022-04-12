# Get config.yml parameters
if (!require("config")) install.packages("config")
config <- config::get()


# Install global project packages not yet installed then load
global.pkgs <- config$global_pkgs

using<-function(...) {
  libs<-unlist(list(...))
  req<-unlist(lapply(libs,require,character.only=TRUE))
  need<-libs[req==FALSE]
  if(length(need)>0){ 
    install.packages(need)
    lapply(need,require,character.only=TRUE)
  }
}

using(global.pkgs)

#source lib scripts
source("lib/download_unzip_data.R")

# Setup project directories
rawdata.path <- file.path(".",config$data_folder,config$raw_data_subfolder)
processed_data.path <- file.path(".",config$data_folder,
                                 config$processed_data_subfolder)
output.path <- file.path(".",config$output_folder)

paths <- c(rawdata.path,processed_data.path,output.path)

for (dir in paths) {
  if(!dir.exists(dir)) {dir.create(dir,recursive = TRUE)}
}

# Clear output folder
if(config$clear_output) {
  # get all files in the directories, recursively
  f <- list.files(output.path, include.dirs = F, full.names = T, recursive = T)
  # remove the files
  file.remove(f)
}

# URL to raw data
data.url <- config$data_url

#datafile
data.filename <- basename(data.url)
data.file <- file.path(data.path,data.filename)

#download data
if(config$refresh_data) {
  dl_metadata <- download_unzip_data(url=data.url,dest=rawdata.path)
}


