library(terra)
library(dplyr)
library(readr)

##MEMORY MANAGEMENT see https://rspatial.org/pkg/10-misc.html  https://rspatial.github.io/terra/reference/terraOptions.html
terra_tempdir <- "E:/Rtemp/terra_tmp"  ## define the name of a temp directory where raster tmp files will be stored
dir.create(terra_tempdir, showWarnings = F, recursive = T)  ## create the directory
terraOptions(tempdir = terra_tempdir)  ## set raster options

fire_path <- "data/mapbiomas-fire/annual-burned-coverage_30/"
age_path <- "data/mapbiomas-rege/age/"

yrs <- seq(from=2011,to=2012,by=1)

#tibble to save all results
outdata <- tibble(
  FireVeg = numeric(),
  VegAge = numeric(),
  N = numeric(),
  Year = numeric()
)

for(yr in yrs){
  
  print(yr)
  print(Sys.time())

  #read fire
  fire <- rast(paste0(fire_path, "mapbiomas_brazil-collection_30-annual_burned_coverage-mata_atlntica-", yr, "-croppedINT_AFclip.tif"))

  #read regen age
  age <- rast(paste0(age_path, "mapbiomas-brazil-collection-80-mataatlntica-", yr, "-regen-age_AFclip.tif"))
  
  #stack rasts
  fireage <- c(fire, age)

  #crosstab
  fireage_ct <- crosstab(fireage, long=TRUE)
  
  #set consistent col names
  names(fireage_ct) <- c("FireVeg", "VegAge", "N")
  
  #add year for bind_rows below
  fireage_ct <- mutate(fireage_ct, Year = yr)
  
  #output just this year to file
  write_csv(fireage_ct, paste0("output/FireAgeCT_",yr,".csv"))
  
  #append to all data tibble
  outdata <- bind_rows(outdata, fireage_ct)
  
  print("complete")
  print(Sys.time())
}
#output all data to file
write_csv(outdata, "output/FireAgeCT_All.csv")
