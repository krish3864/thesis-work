rm breqFast.txt
l=`cat eventCatalogue.txt | wc -l | awk '{print $1-1}'`
for i in `seq 1 1 $l`
do
date1=`cat eventCatalogue.txt | tail -n +2 | awk -v j=$i -F "," 'NR==j {print $3}' | awk -F "-" '{print $1 "\t"$2 "\t"$3}'`
time1=`cat eventCatalogue.txt | tail -n +2 | awk -v j=$i -F "," 'NR==j {print $4}' | awk -F ":" '{print $1 "\t"$2 "\t"$3}' | awk -F "." '{print $1}'`
time2=`cat eventCatalogue.txt | tail -n +2 | awk -v j=$i -F "," 'NR==j {print $4}' | awk -F ":" '{print $1 "\t"$2 "\t"$3}' | awk -F "." '{print $1}' | awk '{if ($1+1<=9 ) print "0"$1+1 "\t"$2 "\t"$3 ; else if ($1==23) print "00" "\t"$2 "\t"$3; else print $1+1 "\t"$2 "\t"$3}'`
ntime2=`echo $time2 | awk '{print $1}'`
ndate1=`echo $date1 | awk '{print $3}'`
date2=`cat eventCatalogue.txt | tail -n +2 | awk -v j=$i -F "," 'NR==j {print $3}' | awk -v a=$ntime2 -v b=$ndate1 -F "-" '{if (a=="00" && b<9) print $1 "\t"$2 "\t""0"$3+1; else if (a=="00") print $1 "\t"$2 "\t"$3+1; else print $1 "\t"$2 "\t"$3}'`
echo DONG "\t"XR "\t"$date1 "\t"$time1 "\t"$date2 "\t"$time2 "\t""\t"3 "\t"BHE "\t"BHN "\t"BHZ >> breqFast.txt
done
