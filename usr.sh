for station in `ls *.e|awk -F".e" '{print $1}'`
do 
for gw in 1.0
do
usr=`sac<<! | grep USER9 |awk '{print $3}'
r ${station}_${gw}.eqr 
lh USER9
q
!`
echo $usr ${station}_${gw}.eqr  | awk '{if ($1>70) print $1 "\t" $2".eqr"}'>> list.dat
done
done
