for file in `cat list.data| awk '{print $0}'`
#for file in `ls *eqr`
do
evt=`echo $file |awk -F"eqr" '{print $1"eq"}'`
baz=`saclhdr -BAZ $file | awk '{print $1}'`
del=`saclhdr -GCARC $file | awk '{print $1}'`
echo "$evt $baz $del"|awk '{printf "%s\t%d\t%d\n", $1,$2,$3}' >> Baz-Del-List
done