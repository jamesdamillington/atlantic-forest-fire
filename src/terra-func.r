library(terra)

#add OS tools to handle \ vs / in paths?

mosaicCropTifs <- functionn(data_path, pat, output,cropper)
{

  files <- list.files(path = data_path, 
                      pattern = paste0(pat,".*\\.tif$"), 
                      full.names = TRUE)
  
  rasters <- c(lapply(files, rast))
  rsrc <- sprc(rasters)
  m <- mosaic(rsrc)
  mr<- resample(m, cropper,method='near')
  masked <- crop(mr,cropper,mask=T)
  writeRaster(masked, paste0(data_path,output))
}

data_path <- "E:/AtlanticForest/atlantic-forest-fire/data/mapbiomas-fire/frequency_30/"
pat <- "mapbiomas_brazil-collection_30-fire_frequency-mata_atlntica-1985_1990-"
output <- "mapbiomas_brazil-collection_30-fire_frequency-mata_atlntica-1985_1990_croppedINT.tif"

cropper <- rast("data/mapbiomas-lulc/MAPBIOMAS-LULC-MATAATLANTICA-CLP/mapbiomas-brazil-collection-80-mataatlantica-lulc-1985.clp.tif")


mosaicTifs(data_path, pat, yrs, cropper)




##MEMORY MANAGEMENT see https://rspatial.org/pkg/10-misc.html  https://rspatial.github.io/terra/reference/terraOptions.html
terra_tempdir <- "E:/Rtemp/terra_tmp"  ## define the name of a temp directory where raster tmp files will be stored
dir.create(terra_tempdir, showWarnings = F, recursive = T)  ## create the directory
terraOptions(tempdir = terra_tempdir)  ## set raster options
## remove the tmp dir
unlink(terra_tempdir, recursive = T, force = T)


tmpFiles(current=TRUE, orphan=T, old=T, remove=FALSE)


#to try as output for INT1U
mint<-mosaic(rsrc,fun='first',datatype="INT1U")
mintr<- resample(mint, cropper,method='near',datatype="INT1U")
maskedr <- crop(mintr,cropper,mask=T,datatype="INT1U")
writeRaster(maskedr, paste0(data_path,output),datatype="INT1U")


