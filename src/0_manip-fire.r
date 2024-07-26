source("src/terra-func.r")

##MEMORY MANAGEMENT see https://rspatial.org/pkg/10-misc.html  https://rspatial.github.io/terra/reference/terraOptions.html
terra_tempdir <- "E:/Rtemp/terra_tmp"  ## define the name of a temp directory where raster tmp files will be stored
dir.create(terra_tempdir, showWarnings = F, recursive = T)  ## create the directory
terraOptions(tempdir = terra_tempdir)  ## set raster options


data_path <- "data/mapbiomas-fire/annual-burned-coverage_30/"
cropper <- rast("data/mapbiomas-lulc/MAPBIOMAS-LULC-MATAATLANTICA-CLP/mapbiomas-brazil-collection-80-mataatlantica-lulc-1985.clp.tif")

yrs <- seq(2011,2011,by=1)

for(yr in yrs){
  print(yr)
  print(Sys.time())
  
  pat <- paste0("mapbiomas_brazil-collection_30-annual_burned_coverage-mata_atlntica-",yr,"-0",".*\\.tif$")
  outfname <- paste0("mapbiomas_brazil-collection_30-annual_burned_coverage-mata_atlntica-",yr,"-mosaicLastINT.tif")

  print("mosaicFlist")
  m <- mosaicFlist(data_path, pat, mfun='last', rdtype="INT1U")

  print("resampleCrop")
  mr <- resampleCrop(m, cropper, resfun='near', cmask=T, rdtype="INT1U")
  
  print("writeRaster")
  writeRaster(m, paste0(data_path,outfname), datatype="INT1U")
  
  print("complete")
  print(Sys.time())
}

## remove the tmp dir
unlink(terra_tempdir, recursive = T, force = T)

#tmpFiles(current=TRUE, orphan=T, old=T, remove=FALSE)



#to try as output for INT1U
#mint<-mosaic(rsrc,fun='first',datatype="INT1U")
#mintr<- resample(mint, cropper,method='near',datatype="INT1U")
#maskedr <- crop(mintr,cropper,mask=T,datatype="INT1U")
#writeRaster(maskedr, paste0(data_path,output),datatype="INT1U")