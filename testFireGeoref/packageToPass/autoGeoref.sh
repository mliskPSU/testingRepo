#!/bin/bash

#create the scripts to georeference and warp the fire color maps
baseDir='/Users/mdl5548/Documents/testFireGeoref/packageToPass/'

#RScript /Users/mdl5548/Documents/testFireGeoref/packageToPass/automateGeoref.R /Users/mdl5548/Documents/testFireGeoref/packageToPass
RScript $baseDir"automateGeoref.R" $baseDir

#run the georeferencing and warping scripts to produce final input
scriptFiles=$(find $baseDir -not -path '*/.*' -type f -name '*_script.sh')

for fle in $scriptFiles;
do
  #echo $fle
  sh $fle
done
