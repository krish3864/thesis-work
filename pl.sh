#!/bin/bash
for station in `cat list.data| awk '{print $0}'`
do
GCARC=`saclhdr -GCARC $station |awk -F"eqr" '{print $1}'`
echo $GCARC
echo $GCARC $station | awk '{if ($1>30 && $1<95) print $1 "\t" $2}' >> list.final
done
 gmt gmtset FONT_ANNOT_PRIMARY 14p,Times-Bold,black
gmt gmtset FONT_LABEL 16p,Times-Bold,black
gmt gmtset MAP_ANNOT_OFFSET_PRIMARY .1
gmt gmtset MAP_TICK_PEN 1p

#gmtset MAP_TICK_LENGTH -.20
#gmtset MAP_TICK_PEN 1p
#gmtset MAP_FRAME_PEN 1p
#gmtset MAP_LABEL_OFFSET 0
##gmtset ANNOT_OFFSET .10
count=1
rm -rf *inp*  Baz-Del-List Eqr-Baz-File
stn=`pwd |awk -F"/" '{print $6}'`
########Sort eqrs wrt BAZ
for file in `cat list.final| awk '{print $r}'`
#for file in `ls *eqr`
do
evt=`echo $file|awk -F"eqr" '{print $1"eq"}'`
baz=`saclhdr -BAZ $file | awk '{print $1}'`
del=`saclhdr -GCARC $file | awk '{print $1}'`
echo "$evt $baz $del"|awk '{printf "%s\t%d\t%d\n", $1,$2,$3}' >> Baz-Del-List
done
sort -g -k2 Baz-Del-List>Sort-Baz-List
rm -rf Baz-Del-List


###For EQR
outfile1=Time-Amp.inp1
more Sort-Baz-List |grep -v \*|awk '{print $1"r"}'>rftn.lst
sfpath=`pwd`
for stack in `cat rftn.lst` ; 
do
#rayp=`saclhdr -USER4 ${sfpath}/$stack`
delta="0.05"
gauss=`saclhdr -USER0 ${sfpath}/$stack`
baz=`saclhdr -BAZ ${sfpath}/$stack`
#Convert original stack file to alpha format
echo "$stack $baz" >>Eqr-Baz-File
sac<<END
r ${sfpath}/$stack
cut -3 80
r ${sfpath}/$stack
w ${sfpath}/${stack}1
convert from sac ${sfpath}/${stack}1 to alpha $stack.a
q
END
sacalphafile=$stack.a
begintime=-2
echo ">" >> $outfile1
awk 'NR > 30 { print $0 }' < $sacalphafile | awk '{ i=1; while (i<NF+1) { print $i; ++i }}' | awk '{ print '$begintime' + '$delta'*(NR-1), $1 }' | awk '{ print $1, '$count', $2 }' >> $outfile1
count=`echo $count |awk '{print $1+1}'`
rm -rf $stack.a ${stack}1
done

#################
scale=0.7		# Scale of plot
num=125
#num=`ls *eqr|wc -l|awk '{print $1+2}'`			# max number of Rfs in main figure
Timemin=-2
Timemax=80

jj="-JX6i/15i"
rrs="-R$Timemin/$Timemax/0/$num"
OUT=RFs.ps
################
scale=.5
gmt psbasemap $jj $rrs -Ba5f1 -Bx+l"Time (s)" -BS -P -X1.0i -Y1i -V -K > ${OUT}        
baz=`saclhdr -BAZ ${sfpath}/$stack`
gmt pswiggle $outfile1 $jj $rrs -G-180 -Z$scale -K -O >> $OUT
gmt pswiggle $outfile1 $jj $rrs -G+30 -Z$scale -W.01 -K -O >> $OUT
gmt pswiggle $outfile1 $jj $rrs -Z$scale -W.01 -K -O >> $OUT
#echo $count|awk '{print 23,$1-3,16,0,5,"ML","RRF"}' | pstext $jj $rrs -Gwhite -K -N -O >> $OUT


more Sort-Baz-List |awk '{print $1,$2}'|awk '{print -5,++count,10,0,5,"ML",$2}' |gmt  pstext $jj $rrs -N -K -O >> $OUT

echo $count|awk '{print -5,$1+.5,14,0,5,"ML","BAZ"}' |gmt  pstext $jj $rrs -N -K -O >> $OUT

#gmt psxy $jj $rrs -Wthick,red,dashed -K -O -V << END >> $OUT
#6.7 0
#6.7 $count
#END
 gmt psxy data1.txt $jj $rrs    -W1 -K -O -Wthinner >> $OUT
echo "6.5 $count 16 0 5 "ML" Ps"|gmt pstext $jj $rrs -N -O >> $OUT


#echo $count|awk '{print -6,$1+.5,16,0,5,"ML","'$stn'"}' | pstext $jj $rrs -N -O >> $OUT

evince $OUT
