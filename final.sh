rm deamp.txt lalong_410.txt lalong_520.txt lalong_660.txt 
count=28.5
for lon_minr in `seq 28 0.5 33.5`
do
for i in *.tbl
do
line_410=`cat $i  | grep P410s`
lalong_410=`echo $line_410 | awk '{print $11,$10}'`
echo $lalong_410 >> lalong_410.txt
lat_410=`echo $line_410 | awk '{print $11}'`
lon_410=`echo $line_410 | awk '{print $10}'`

line_520=`cat $i  | grep P520s`
lalong_520=`echo $line_520 | awk '{print $11,$10}'`
echo $lalong_520 >> lalong_520.txt
lat_520=`echo $line_520 | awk '{print $11}'`
echo $lat_520 >> lat520.txt
lon_520=`echo $line_520 | awk '{print $10}'`

line_660=`cat $i  | grep P660s`
lalong_660=`echo $line_660 | awk '{print $11,$10}'`
echo $lalong_660 >> lalong_660.txt
lat_660=`echo $line_660 | awk '{print $11}'`
lon_660=`echo $line_660 | awk '{print $10}'`

lat_maxr=90
lat_minr=84
echo  $lat_520 $lon_520 

lon_maxr=`echo $lon_minr | awk '{print $1+1}'`
echo $lon_maxr $lon_minr
echo $lat_maxr $lat_minr $lon_maxr $lon_minr $lat_520 $lon_520 $i | awk '{if($5>$2 && $5<$1 && $6>$4 && $6<$3) print $7 }'  >> filter.txt

done

line_no=`cat 101_2004.206.18.54.57.tbl  | wc -l`

for i in  `seq 1 1 $line_no`
do
sum=0
l_no=`cat filter.txt | wc -l`
depth=`cat 101_2004.206.18.54.57.tbl  | awk -v l=$i 'NR==l{print $15}'`
	for j in $(cat filter.txt)
	do
	amp=`cat $j | awk -v l=$i 'NR==l{print $14}'`
	sum=`echo $sum $amp | awk '{print $1+$2}'`
	done
avg=`echo $sum $l_no | awk '{print $1/$2}' | awk  '{printf ("%0.11f" ,$1)}'`

echo $avg $depth| awk '{print $2,'$count',$1}'  >> dea

done
echo ">" >> dea
count=`echo $count |awk '{print $1+0.5}'`
rm filter.txt
done
#more deamp.txt| gmt psxy -R-.01/0.016/300/800 -JX2i/6i -P -Bxa0.1 -Bya100 > taupnn.ps
#evince taupnn.ps





