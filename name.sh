for i in *_1.6.eqr
do
j=`echo $i | awk -F "_" '{print $1}'`
mv $i $j
echo $i $j
break
done