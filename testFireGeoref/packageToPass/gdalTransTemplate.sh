#!/bin/bash

gdal_translate \
  -gcp \
  -of GTiff \
  /Users/.jpeg \
  /Users/gdalTrans.tif

#documentation: https://gdal.org/programs/gdalwarp.html
gdalwarp \
  -tps \
  -r cubic \
  -s_srs "EPSG:4326" \
  -t_srs "EPSG:3857" \
  -co TILED=YES \
  -overwrite \
  /Users/gdalTrans.tif \
  /Users/gdalTransProj.tif
