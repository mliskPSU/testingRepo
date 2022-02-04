#!/bin/bash

#requires ImageMagick
baseDir='/Users/mdl5548/Documents/GitHub/testingRepo/testFireGeoref/packageToPass/'
probsDir=$baseDir'fireProbabilities/'
fileToExtractFrom='Technosylva Report on SCE PSPS Events 2019.pdf'
#cd /Users/mdl5548/Documents/GitHub/testingRepo/testFireGeoref/packageToPass/

#legend lower right, scale upper right
llrsurMapPages="65 69 77 81 89 101"
for mapPg in $llrsurMapPages;
do
  convert -density 300 -crop 2386x1822+456+400 "$fileToExtractFrom[$mapPg]" -fill black -draw "rectangle 1968,1131 2386,1822" -draw "rectangle 1449,1782 2386,1822" -draw "rectangle 1857,0 2386,160" -alpha off -quality 100 "./fireProbabilities/fireProbMap_$mapPg.jpeg"
done

#legend lower left, scale upper right
lllsurMapPages="73 93 97 105"
for mapPg in $lllsurMapPages;
do
  convert -density 300 -crop 2386x1822+456+400 "$fileToExtractFrom[$mapPg]" -fill black -draw "rectangle 0,1120 425,1822" -draw "rectangle 1449,1782 2386,1822" -draw "rectangle 1857,0 2386,160" -alpha off -quality 100 "./fireProbabilities/fireProbMap_$mapPg.jpeg"
done

#legend lower left, scale lower right
lllslrMapPages="85"
for mapPg in $lllslrMapPages;
do
  convert -density 300 -crop 2386x1822+456+400 "$fileToExtractFrom[$mapPg]" -fill black -draw "rectangle 1449,1782 2386,1822" -draw "rectangle 1857,0 2386,160" -alpha off -quality 100 "./fireProbabilities/fireProbMap_$mapPg.jpeg"
done
