for station in `cat list.dat| awk '{print $2}'`
do
GCARC=`saclhdr -GCARC $station |awk -F"eqr" '{print $1}'`
echo $GCARC
echo $GCARC $station | awk '{if ($1>30 && $1<95) print $1 "\t" $2}' >> list.dataa
done
