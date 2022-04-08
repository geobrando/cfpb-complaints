source("setup.R")

#import data

cfpb.df <- read_csv(list.files(rawdata.path,full.names = TRUE)[1])