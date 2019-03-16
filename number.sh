rm deamp.txt lalong_410.txt lalong_520.txt lalong_660.txt lat520.txt
#count=31.5
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
lon_maxr=32.5
lon_minr=31.5
#echo  $lat_520 $lon_520 

#lon_maxr=`echo $lon_minr | awk '{print $1+1}'`
#echo $lon_maxr $lon_minr
echo $lat_maxr $lat_minr $lon_maxr $lon_minr $lat_520 $lon_520 $i | awk '{if($5>$2 && $5<$1 && $6>$4 && $6<$3) print $7 }'  >> filter32.txt

done

