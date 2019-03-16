gmt psbasemap -R28/34/380/680 -JX6i/-3i -Byf.5 -Bxa0.5+l"Latitude" -BWESn -K -P > taup21.ps
more 660.txt | awk ' {print $2"\t" $1}'| gmt psxy -R -J -P -B -K -O -Gblue -St.2c >> taup21.ps

cat 660.txt | awk '{print $2"\t"$5+2"\t"$4}' | gmt pstext -R -J -B -P -F+f10,black+a0  -O -K >> taup21.ps
#gmt psbasemap -R28/34/400/430 -JX6i/-5i  -Byg5 -Bx -BEW -K -O -P -Y4.2 >> taup21.ps
more 410.txt | awk ' {print $2"\t" $1}'| gmt psxy -R -J -P -B -K -O -Gblack -St.2c >> taup21.ps
cat 410.txt | awk '{print $2"\t"$5"\t"$4}' | gmt pstext -R -J -B -P -F+f10,black+a0  -K -O >> taup21.ps
gmt psconvert taup21.ps -A02c+pthick -Tg

evince taup21.ps &

