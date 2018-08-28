for station in `ls *.e|awk -F".e" '{print $1}'`
do 
#. ~/.profile

for file in `cat list.final| awk -F '{print $2}'`
do
sac<<!
r ${station}.z ${station}.n ${station}.e
fileid t n
sync
rmean
rtrend
bp co 0.1 3 n 2 p 2
cut t0 -50 120
read
cut off
w ${station}.z.cut ${station}.n.cut ${station}.e.cut
r ${station}.n.cut ${station}.e.cut
taper
rotate to gcarc
w ${station}.r ${station}.t
q
!
done

for station in `ls *.e|awk -F".e" '{print $1}'`
do 
for gw in 0.6 1.0 1.6 
do
iterdecon<<!
${station}.r
${station}.z.cut
200
5
0.001
$gw
1
0
!
cp decon.out ${station}.eqr
echo "RFs"
#done
usr=`sac<<! | grep USER9 |awk '{print $3}'
r $station.eqr 
lh USER9
q
!`
echo $usr $station  | awk '{if ($1>70) print $1 "\t" $2".eqr"}'>> list.dat
done


