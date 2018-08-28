for station in `cat list.dat | awk '{print $2}'`
do 
gmt pssac $station -R-2/85/24/364 -JX18c/15c -Bx5+l'Time(s)' -Fr   -Gp+gblack -Gn+gblue -By5+l'BAZ(Degree)' -BWS \
    -Eb -M3.1c -W0.2p,black -K > $station.single.ps
    gmt psxy data1.txt -R -J    -W1 -O -Wthinner >> $station.single.ps
#gmt pssac $station.eqr -JX18c/15c -R-2/85/25/100 -Baf -Fr -Gp+gblack -Gn+gred -BWS \
 #-Eb -M3.1c -W0.2p,black  evince $station.single.ps
done
rm list.dat
for l in *.ps
do
echo $l >>PS.txt
done
for i in $(cat PS.txt | tail -n +4)
do
evince $i
evnt=`echo $i | awk -F".single" '{print $1}'`
read -p "please enter y or n:" ans
echo $ans $evnt | awk '{if($1=="y") {print $2".eqr"} else if($1=="n") {}}' >>list.data
done 
