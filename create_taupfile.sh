#!/bin/bash
for file in `ls *.taup`
do
stn=`echo $file|awk -F"." '{print $1}'`
#echo $stn

#ls *eqr|grep $stn > inputfile
for evt in `cat list.data`
do
echo "Calculating piercing point for $evt"
str=`sac<<!|egrep "STLA|STLO|EVLA|EVLO"|awk '{print $3}'
r $evt
lh STLA
lh STLO
lh EVLA
lh EVLO
q
!`
dep=`sac<<!|grep EVDP|awk '{print $3/1000}'
r $evt
lh EVDP
q
!` 
echo $str
stla=`echo $str|awk '{print $1}'`
stlo=`echo $str|awk '{print $2}'`
evla=`echo $str|awk '{print $3}'`
evlo=`echo $str|awk '{print $4}'`
echo $stla
echo $stlo
echo $evla
echo $evlo

seq 150 2 850 |awk '{print "P"$1"s"}' > p2s.dat

echo "$stla $stlo $evla $evlo $dep" 
file_name=`echo $evt|awk -F".eqr" '{print $1}'`
taup_pierce -ph P -sta $stla $stlo -evt $evla $evlo -h $dep -mod $file | grep ">"|head -1 > ${file_name}.pierce
taup_pierce -pf p2s.dat -sta $stla $stlo -evt $evla $evlo -h $dep -mod $file >> ${file_name}.pierce

sac<<!
r ${file_name}.eqr
convert from sac ${file_name}.eqr to alpha ${file_name}.asc
q
!
done

done
#rm -rf *_eqr_list
