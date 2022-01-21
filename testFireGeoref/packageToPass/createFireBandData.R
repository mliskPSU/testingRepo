library(kohonen)

baseDir <- "/Users/mdl5548/Documents/testFireGeoref/packageToPass"
projFireFiles <- list.files(baseDir, pattern="_gdalTransProj.", full.names=T, recursive=T)
#projFireFiles <- projFireFiles[-c(1,4,6)]
projFireRasts <- lapply(projFireFiles, brick)
projFireRasts <- lapply(projFireRasts, function(rgb){names(rgb)<-c("red","green","blue");return(rgb)})

somModelObjs <- list.files(baseDir, pattern="saveFittedSOM.RData", full.names=T, recursive=T)
load(somModelObjs)
plotCols <- c("orange", "#fa9fb5", "lightgreen", "#969696", "lightpink", "#969696", "#969696", "#969696", "#969696", "cyan", 
              "#969696", "#969696", "black", "#969696", "red")

# ptm1 <- proc.time()
# clustRast <- lapply(projFireRasts, function(rastLyr, somMod, somCstTab){rastPts<-SpatialPoints(rastLyr)
#                                                       ##get cell numbers
#                                                       cellNums<-cellFromXY(rastLyr,rastPts)
#                                                       rgbVals<-cbind.data.frame(cellNums,getValues(rastLyr))
#                                                       colnames(rgbVals)[2:4]<-c("red","green","blue")
#                                                       ##remove pure black areas, as they are known to not be the data we are looking for
#                                                       rgbVals<-rgbVals[-c(which(rgbVals$red==0 & rgbVals$green==0 & rgbVals$blue==0)),]
#                                                       onlyRGB <- rgbVals[,2:ncol(rgbVals)]
#                                                       
#                                                       ##predict the SOM clustering onto the loaded images
#                                                       somPred <- predict(som_model, as.matrix(onlyRGB))
#                                                       
#                                                       ##assigning cluster back to data
#                                                       fillTab <- cbind.data.frame(rgbVals$cellNums, as.matrix(onlyRGB), somPred$unit.classif)
#                                                       colnames(fillTab)[5] <- "unitClass"
#                                                       fillTab <- merge(x=fillTab, y=somCstTab, by.x="unitClass", by.y="somHexes")
#                                                       ##maps values back to raster
#                                                       somClustLyr <- rastLyr[[1]]
#                                                       somClustLyr[] <- NA
#                                                       somClustLyr[fillTab$`rgbVals$cellNums`] <- fillTab$som_cluster
#                                                       return(somClustLyr)}, somMod=som_model, somCstTab=somClusterTab)
# endTime1 <- proc.time() - ptm1

somMod<-som_model 
somCstTab<-somClusterTab
clustRast<-list()
for(rastLyr in projFireRasts){
  rastPts<-SpatialPoints(rastLyr)
  ##get cell numbers
  cellNums<-cellFromXY(rastLyr,rastPts)
  rgbVals<-cbind.data.frame(cellNums,getValues(rastLyr))
  colnames(rgbVals)[2:4]<-c("red","green","blue")
  ##remove pure black areas, as they are known to not be the data we are looking for
  rgbVals<-rgbVals[-c(which(rgbVals$red==0 & rgbVals$green==0 & rgbVals$blue==0)),]
  onlyRGB <- rgbVals[,2:ncol(rgbVals)]
  
  ##predict the SOM clustering onto the loaded images
  somPred <- predict(som_model, as.matrix(onlyRGB))
  
  ##assigning cluster back to data
  fillTab <- cbind.data.frame(rgbVals$cellNums, as.matrix(onlyRGB), somPred$unit.classif)
  colnames(fillTab)[5] <- "unitClass"
  fillTab <- merge(x=fillTab, y=somCstTab, by.x="unitClass", by.y="somHexes")
  ##maps values back to raster
  somClustLyr <- rastLyr[[1]]
  somClustLyr[] <- NA
  somClustLyr[fillTab$`rgbVals$cellNums`] <- fillTab$som_cluster
  
  clustRast[length(clustRast)+1] <- somClustLyr
  
  ##get the name of the file in order to name output
  rastName <- rastLyr@file@name
  dataFile <- gsub("gdalTransProj.tif", "clusteredData.tif", rastName)
  imageFile <- gsub("gdalTransProj.tif", "clusteredDataMap.tif", rastName)
  
  writeRaster(somClustLyr, dataFile, overwrite=T)
  tiff(imageFile, width=ncol(somClustLyr)+200, height=nrow(somClustLyr)+200)
  plot(somClustLyr, col=plotCols, maxpixels=1000000)
  dev.off()
}


#plot(clustRast[[1]], col=plotCols)
#plot(clustRast[[2]], col=plotCols)
#plot(clustRast[[3]], col=plotCols)
#plot(clustRast[[4]], col=plotCols)
#plot(clustRast[[5]], col=plotCols)
#plot(clustRast[[6]], col=plotCols)

# clust1 <- clust2 <- clust3 <- clust4 <- clust5 <- clust6 <- clust7 <- clust8 <- clust9 <- clust10 <- clust11 <- clust12 <- clust13 <- clust14 <- clust15 <- clustRast2[[3]]
# clust1[clust1!=1] <- NA  ##60-80, orange
# clust2[clust2!=2] <- NA  ##10-20, dark pink
# clust3[clust3!=3] <- NA  ##40-60, light green
# clust4[clust4!=4] <- NA
# clust5[clust5!=5] <- NA  ##5-10, light pink
# clust6[clust6!=6] <- NA
# clust7[clust7!=7] <- NA
# clust8[clust8!=8] <- NA
# clust9[clust9!=9] <- NA
# clust10[clust10!=10] <- NA  ##20-40, cyan
# clust11[clust11!=11] <- NA
# clust12[clust12!=12] <- NA
# clust13[clust13!=13] <- NA  ##Deterministic perimeter
# clust14[clust14!=14] <- NA  
# clust15[clust15!=15] <- NA  ##80=100, red




