rm -rf List
for file in `ls *eqr`
do
sac<<!
r $file
cut 1.5 100
r
cut off
w k.eqr
q
!
max=`saclhdr -DEPMAX k.eqr | awk '{printf "%d\n", $1*100}'`
min=`saclhdr -DEPMIN k.eqr | awk '{printf "%d\n", $1*100}'`
echo $file $max $min
echo $file $max $min >> List
if [ $max -ge 30 || $min -le -20 ] ; then
mv $file /home/krish/THESIS/BAD/
fi
rm -rf k.eqr
done
mkdir BAD
