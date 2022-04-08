

download_unzip_data <- function(url,dest=NULL) {
  # 1) Downloads a zip file from a url to a temp file, 
  # 2) Unzips to a "./data/raw" folder by default
  # 3) returns list with paths to unzipped file(s)
  
  if(is.null(dest)) {dest <- file.path(".","data","raw")}
  
  tryCatch(
    {
      temp <-tempfile()
      message("Attempting to download data...")
      download.file(data.url,destfile = temp )
      message("Unzipping data file...")
      files <- unzip(zipfile = temp,list=TRUE)
      unzip(zipfile = temp,exdir = dest)
      unlink(temp)
    },
    error=function(cond) {
      message("Error message when attempting to download and unzip file:")
      message(cond)
    },
    warning=function(cond) {
      message("Warning message when attempting to download and unzip file:")
      message(cond)
    },
    finally={
      message(paste("Successfully downloaded file from",url,"and unzipped to",
                    dest))
      return(files)
    }
  )
}




