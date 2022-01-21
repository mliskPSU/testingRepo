
##check to make sure that the user has provided a path in which the input files are stored
args <- commandArgs(trailingOnly=TRUE)
baseDir <- args[1]
#baseDir <- "/Users/mdl5548/Documents/testFireGeoref/packageToPass"
baseDir <- paste0(baseDir, "/")

#library(rgdal)
library(sp)
library(raster)

anchorPts <- read.csv(paste0(baseDir, "test_fire_anchorPts.csv"))

##read in the script template
findTempFile <- paste0(baseDir, "gdalTransTemplate.sh")
templateScript <- paste(readLines(findTempFile), collapse="\n")

##cycle through each prepared area
for(i in unique(anchorPts$area)){
  areaAnchors <- anchorPts[anchorPts$area==i,]

  ##Convert the points from the projected coordinates given by https://www.georeferencer.com/ into
  ##WGS84 coordinates
  spAnchorPts <- SpatialPoints(cbind(areaAnchors$projPtX,areaAnchors$projPtY), proj4string=crs("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs"))
  #spAnchorPts <- SpatialPoints(cbind(areaAnchors$projPtX,areaAnchors$projPtY), proj4string=crs("+init=epsg:3857"))
  projAnchorPts <- spTransform(spAnchorPts, "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  ##fill out the coordinates to be placed in the shell script
  fillOutCoords <- paste("-gcp", areaAnchors$pixPtX, areaAnchors$pixPtY, projAnchorPts@coords[,1], projAnchorPts@coords[,2], collapse=" ")

  ##substitute portions of the template with actual values
  modScript <- gsub("-gcp", fillOutCoords, templateScript)  ##add the image coordinates
  modScript <- gsub("/Users/.jpeg", paste0(baseDir, "fireProbabilities/test_fire", i, "_crop.jpeg"), modScript)  ##add the input file name and directory
  modScript <- gsub("/Users/gdalTrans.tif", paste0(baseDir, "fireProbabilities/test_fire", i, "_gdalTrans.tif"), modScript)  ##add the temporary file between translate and warp
  modScript <- gsub("/Users/gdalTransProj.tif", paste0(baseDir, "fireProbabilities/test_fire", i, "_gdalTransProj.tif"), modScript)  ##add the projected warped file

  ##area script
  newScriptFile <- paste0(baseDir, "test_fire", i, "_script.sh")
  writeLines(modScript, newScriptFile)
}

