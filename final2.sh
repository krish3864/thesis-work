s="/home/krish/THESIS/codes/mby.cpt" 
gmt psbasemap -R80/92/26/36 -JM6.5i -Bp2/2WESN -K   -P > taup.ps
gmt pscoast -JM6.5i -R -Bp2/2WESN  -Df+  -S102/178/255 -O -K -P >> taup.ps
gmt grdcut /home/krish/THESIS/codes/ETOPO1_Bed_g_gmt4.grd -Gtopo0.grd -R
gmt grdsample topo0.grd -Gtopoh.grd -I0.005 -nb+t0.1
gmt grdgradient topoh.grd -Gtopoh.int -A45 -Nt
gmt grdimage topoh.grd -Itopoh.int -C$s -J -R -B  -O -K -P >> taup.ps #-S doesn't work for this line.
for files in *p.txt 
do
cat $files | gmt psxy -J -R -K -O -P -W1.5p,black,solid >> taup.ps
cat coordinate.txt | awk '{print $1"\t"$2"\t"$3}' | gmt pstext -R -J -B -P -F+f16,black+a0 -Gwhite -W1p,blue,solid -Qu -O -K  >> taup.ps
done



#more station.txt | awk ' {print $4"\t"$3+0.35"\t"$1}'| gmt pstext -R -J  -P -F+f4p,Helvetica-Bold -B -K -O  >> taup.ps
more station.txt | awk ' {print $4"\t" $3}'| gmt psxy -R  -P -J -B -K  -O -Gblack -St.3c >> taup.ps
more lalong_410.txt | awk '{print $1"\t"$2}'| gmt psxy -R  -P -J -B -K -O -Gred -Sc.1c >> taup.ps
#more lalong_520.txt | awk '{print $1"\t"$2}'| gmt psxy -R  -P -J -B  -K -O -Ggreen  -Sc.1c >> taup.ps
more lalong_660.txt | awk '{print $1"\t"$2}'| gmt psxy -R  -P -J -B   -O -Gblue  -Sc.1c >> taup.ps
gmt psconvert taup.ps -A0.2c+pthick -Tg

evince taup.ps

