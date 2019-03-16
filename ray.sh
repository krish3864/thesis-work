
gmt psbasemap -R80/90/150/800 -JX6i/-6i -Bag -By+l"longitude(degree)" -Bx+l"Depth(km)" -BSW -K -P > taup2.ps
more deplong.txt | awk ' {print $1"\t" $2}'| gmt psxy -R80/90/150/800 -J -P -B  -O -Gblack -St.05c >> taup2.ps
gmt psconvert taup2.ps -A02c+pthick -Tg

evince taup2.ps


