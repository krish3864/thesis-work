#!/bin/bash
###
####### Radial and Transverse RF for Gw 2.5
###
for files in `ls *.z|awk '{print substr($0,1,22)}'`
do
#####Filter .01-1 Hz Band pass
echo r $files'z' $files'n' $files'e' > sac.mac
echo rmean >> sac.mac
echo rtrend >> sac.mac
echo sync >> sac.mac
###For Short Period with f band 0.5 to 10 Hz
echo bp co 0.2 2 n 2 p 2 >> sac.mac
echo w $files'zf' $files'nf' $files'ef' >> sac.mac
echo quit >> sac.mac
/usr/local/sac/bin/sac sac.mac
rm -rf sac.mac
#End
##### P and S are marked using Taup for P (T7 marker) and S (T8 marker) receiver function
echo $files | awk '{print "taup_setsac -ph P-7,S-8",substr($0,1,22)"zf",substr($0,1,22)"nf",substr($0,1,22)"ef"}'|sh
#End
####Cut Waveform 30 s before and 120 s after P
echo r $files'zf' $files'nf' $files'ef' > sac.mac
echo cut t7 -50 +120 >> sac.mac
echo r >> sac.mac
#echo rmean >> sac.mac
#echo rtr >> sac.mac
#echo taper w 0.1 >> sac.mac
echo w $files'zc' $files'nc' $files'ec' >> sac.mac
echo cut off >> sac.mac
echo r $files'nc' $files'ec' >> sac.mac
echo rotate to gcp >> sac.mac
echo w $files'r' $files't' >> sac.mac
echo quit >> sac.mac
/usr/local/sac/bin/sac sac.mac
rm -rf sac.mac
#END
##########################RF calculation from Iterdecon ################
############Gw=2.5 for radial eqr and Transverse eqt####################
stn=`echo $files |awk -F"_" '{print $1}'`
nm=`echo $files |awk -F"_" '{print $2}'`
Gw=2.0

###Radial RF
echo iterdecon '<<end' > it.sh
echo $files'r' >> it.sh
echo $files'zc' >> it.sh
echo 200 >> it.sh       #* nbumps
echo 5.0 >> it.sh       #* phase delay for result
echo 0.001 >> it.sh     #* min error improvement to accept
echo $Gw >> it.sh       #* Gaussian width factor
echo 1 >> it.sh         #* 1 allows negative bumps
echo 0 >> it.sh         #* 0 form minimal output (1) will output lots of files
echo end >> it.sh
sh it.sh
rm -rf it.sh
mv decon.out 'P_'$stn'.'$nm'eqr'

###Transverse RF
echo iterdecon '<<end' > it.sh
echo $files't' >> it.sh
echo $files'zc' >> it.sh
echo 200 >> it.sh       #* nbumps
echo 5.0 >> it.sh       #* phase delay for result
echo 0.001 >> it.sh     #* min error improvement to accept
echo $Gw >> it.sh       #* Gaussian width factor
echo 1 >> it.sh         #* 1 allows negative bumps
echo 0 >> it.sh         #* 0 form minimal output (1) will output lots of files
echo end >> it.sh
sh it.sh
rm -rf it.sh
mv decon.out 'P_'$stn'.'$nm'eqt'

done
echo "PROCESSING COMPLETE........"
