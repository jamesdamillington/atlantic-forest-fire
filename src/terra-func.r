library(terra)


#' mosaic a list of files
#' @param pat (char) is a regex filename to create a list of files
#' @param mfun (char, optional) is the mosaic function to use
#' @param rdtype (char, optional) is the output data type for mosaicked raster 
mosaicFlist <- function(data_path, pat,mfun=NULL,rdtype=NULL)
{
  files <- list.files(path = data_path, 
                      pattern = pat, 
                      full.names = TRUE)
  print(paste0("mosaicking ", length(files), " files"))
  
  rasters <- c(lapply(files, rast))  #apply rast function over list of filenames
  rsrc <- sprc(rasters) #Create a SpatRasterCollection

  if(is.null(mfun) & is.null(rdtype)){
    m <- mosaic(rsrc)
    } else if(!is.null(mfun) & !is.null(rdtype)) {
      m <- mosaic(rsrc,fun=mfun,datatype=rdtype)
      } else {
        if(!is.null(mfun)) { m <- mosaic(rsrc,fun=mfun) 
          } else { m <- mosaic(rsrc,datatype=rdtype)}
  }
  
  return(m)
}


#' resample, crop, mask
#' @param cropper (SpatRaster) is the reference raster against which to resample, crop and (optionally) mask
#' @param resfun (char, optional) is the method resample used for estimating new cell values
#' @param cmask (bool, optional) mask option in terra::crop 
#' @param rdtype (char, optional) datatype of returned SpatRaster (see terra::writeRaster)
resampleCrop <- function(r, cropper, resfun=NULL, cmask=NULL, rdtype=NULL)
{

  #example: rr <- resample(r, cropper, method='near',datatype="INT1U")
  if(is.null(resfun) & is.null(rdtype)){
    rr <- resample(r, cropper)
  } else if(!is.null(resfun) & !is.null(rdtype)) {
    rr <- resample(r, cropper,method=resfun,datatype=rdtype)
  } else {
    if(!is.null(resfun)) { rr <- resample(r, cropper,method=resfun) 
    } else { rr <- resample(r, cropper,datatype=rdtype)}
  }
  
  #example: rrm <- crop(rr,cropper,mask=T,datatype="INT1U")
  if(is.null(cmask) & is.null(rdtype)){
    rrm <- crop(rr,cropper)
  } else if(!is.null(cmask) & !is.null(rdtype)) {
    rrm <- crop(rr,cropper,mask=cmask,datatype=rdtype)
  } else {
    if(!is.null(cmask)) { rrm <- crop(rr,cropper,mask=cmask) 
    } else { rrm <- crop(rr,cropper,datatype=rdtype)}
  }
  
  return(rrm)
}




