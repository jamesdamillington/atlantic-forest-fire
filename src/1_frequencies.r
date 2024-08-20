library(terra)
library(dplyr)
library(readr)
library(glue)

##MEMORY MANAGEMENT see https://rspatial.org/pkg/10-misc.html  https://rspatial.github.io/terra/reference/terraOptions.html
terra_tempdir <- "E:/Rtemp/terra_tmp"  ## define the name of a temp directory where raster tmp files will be stored
dir.create(terra_tempdir, showWarnings = F, recursive = T)  ## create the directory
terraOptions(tempdir = terra_tempdir)  ## set raster options

#input data paths
fire_path <- "data/mapbiomas-fire/annual-burned-coverage_30/"
age_path <- "data/mapbiomas-rege/age/"

yrs <- seq(from=2000,to=2021,by=1)

FAVAct <- F
FAVAfreq <- T

######## crosstab of all Fire Veg vs Veg Age  ########
if(FAVAct){
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
    fire <- rast(paste0(fire_path, "mapbiomas_brazil-collection_30-annual_burned_coverage-mata_atlntica-", yr, "-croppedINT.tif"))
    NAflag(fire) <-0
    
    #read regen age
    age <- rast(paste0(age_path, "mapbiomas-brazil-collection-80-mataatlntica-", yr, "-regen-age.tif"))
    NAflag(age) <- 0
    
    #stack rasts
    fireage <- c(fire, age)
  
    #crosstab
    fireage_ct <- crosstab(fireage, long=TRUE)
    
    #set consistent col names
    names(fireage_ct) <- c("FireVeg", "VegAge", "N")
    
    #add year for bind_rows below
    fireage_ct <- mutate(fireage_ct, Year = yr)
    
    #output just this year to file
    write_csv(fireage_ct, paste0("output/FireAgeCT/FireAgeCT_",yr,".csv"))
    
    #append to all data tibble
    outdata <- bind_rows(outdata, fireage_ct)
    
    print("complete")
    print(Sys.time())
  }
  #output all data to file
  write_csv(outdata, "output/FireAgeCT/FireAgeCT_All.csv")
}

######## frequency of individual variables (Veg or Fire)  ########

if(FAVAfreq)
{
  fvar = "VegAge"    #specify variable to calculate
  
  #tibble to save all results
  freqdata <- tibble(
    "{fvar}" := numeric(),   #from glue package
    N = numeric(),
    Year = numeric()
  )
  
  for(yr in yrs){
    
    print(yr)
    print(Sys.time())
  
    if(fvar=="VegAge") {
      #read regen age
      rdat <- rast(paste0(age_path, "mapbiomas-brazil-collection-80-mataatlntica-", yr, "-regen-age.tif"))
    }
    
    if(fvar=="FireAge"){
      #read fire
      rdat <- rast(paste0(fire_path, "mapbiomas_brazil-collection_30-annual_burned_coverage-mata_atlntica-", yr, "-croppedINT.tif"))
    }
    
    NAflag(rdat) <- 0
    
    rdatFreq <- freq(rdat, bylayer=F)
    
    #set consistent col names
    names(rdatFreq) <- c(fvar, "N")
    
    #add year for bind_rows below
    rdatFreq <- mutate(rdatFreq, Year = yr)
    
    #output just this year to file
    write_csv(rdatFreq, paste0("output/",fvar,"Freq/",fvar,"Freq_",yr,".csv"))
    
    #append to all data tibble
    freqdata <- bind_rows(freqdata, rdatFreq)
  
    print("complete")
    print(Sys.time())
  }
  #output all data to file
  write_csv(freqdata, paste0("output/",fvar,"Freq/",fvar,"Freq_",min(yrs),"-",max(yrs),".csv"))
}


## remove the tmp dir
unlink(terra_tempdir, recursive = T, force = T)
