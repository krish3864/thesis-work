


for file in `cat list.dataa| awk '{print $0}'`
do
h=`cat model.tvel | awk '{print  $1}'
for k in $h
do
taup_time -mod model.tvel  -ph P$hs -deg $GCARC | tail -n +6 | awk '{print $4}' >> time1.txt
taup_time -mod model.tvel -ph P$hp -deg $GCARC | tail -n +6 | awk '{print $4}'  >> time2.txt
for i in `seq 1 1 10`
do
a=`cat time1.txt | awk -v f=$i 'NR==f {print $1}'
b=`cat time2.txt | awk -v f=$i 'NR==f {print $1}'
echo $a $b $k | awk '{print ($1-$2) "\t" $3}' >> timefinal.txt
done
done
done
#for i in `seq 1 1 10`
#do
#t=`cat timefinal.txt | awk  '{print $1}'
#T=`cat amplitude.txt | awk -v f=$i 'NR==f {print $1}'
#if [ $t -eq $T  ] 
#then

	#statements
#fi

for j in `ls amplitude.txt`
do

for i in `ls timefinal.txt`
do
t1=`echo $i | awk '{print $1}'`
done

t2=`echo $j | awk '{print $1}'`
echo $j | awk '{if ($t1==$t2) print $2}' >> ampl.txt
done




