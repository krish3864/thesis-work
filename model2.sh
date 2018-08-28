for file in `cat list.dataa| awk ''
for file in `cat list.dataa| awk '{print $0}'`
do
GCARC=`saclhdr -GCARC $file |awk -F"eqr" '{print $1}'`
h=`cat model.tvel | awk '{print  $1}'
for k in $h
do
taup_time -mod model.tvel  -ph P${k}s -deg $GCARC | tail -n +6 | awk '{print $4}' >> time1.txt
taup_time -mod model.tvel -ph P${k}p -deg $GCARC | tail -n +6 | awk '{print $4}'  >> time2.txt
for i in `seq 1 1 400`
do
a=`cat time1.txt | awk -v f=$i 'NR==f {print $1}'
b=`cat time2.txt | awk -v f=$i 'NR==f {print $1}'
echo $a $b $k | awk '{print ($1-$2) "\t" $3}' >> timefinal.${GCARC}.txt
done
done
done