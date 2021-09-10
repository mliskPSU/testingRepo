#xDat <- 1:10
#yDat <- c(1:5,5:1)

#tiff("./createPlotFile.tif")
#plot(xDat, yDat, pch=20, col="blue")
#dev.off()

library(raster)

randDat <- raster(matrix(sample(1:10, 100, replace=T),nrow=10,ncol=10))

tiff("./createPlotFile.tif")
plot(randDat)
dev.off()