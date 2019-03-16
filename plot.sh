scale=.7		# Scale of plot
num=34
#num=`ls *eqr|wc -l|awk '{print $1+2}'`			# max number of Rfs in main figure
depthmin=300
depthmax=800

jj="-JX6i/6i"
rrs="-R$depthmin/$depthmax/28/$num"
OUT=RFs.ps
################
scale=.02
gmt psbasemap $jj $rrs -Bxa50f10 -Bya.5  -Bx+l"Depth(km)" -By+l"latitude(degree)" -BSW -P  -V -K > ${OUT}        
gmt pswiggle dea $jj $rrs -G-blue -Z$scale -W.01 -K -O >> $OUT
gmt pswiggle dea $jj $rrs -Gred -Z$scale -W.01 -K -O >> $OUT
gmt pswiggle dea $jj $rrs -Z$scale -W.01 -K -O >> $OUT
#echo $count|awk '{print 23,$1-3,16,0,5,"ML","RRF"}' | pstext $jj $rrs -Gwhite -K -N -O >> $OUT


#more Sort-Baz-List |awk '{print $1,$2}'|awk '{print -5,++count,10,0,5,"ML",$2}' |gmt  pstext $jj $rrs -N -K -O >> $OUT

#echo $count|awk '{print -5,$1+.5,14,0,5,"ML","BAZ"}' |gmt  pstext $jj $rrs -N -K -O >> $OUT

#gmt psxy $jj $rrs -Wthick,black,dashed -K -O -V << END >> $OUT
#410 28
#410 $num
#END
#gmt psxy $jj $rrs -Wthick,black,dashed -K -O -V << END >> $OUT
#660 28
#660 $num
#END
#gmt psxy dataz.txt $jj $rrs -W1 -K -v -O -Wthinner >> $OUT
#echo "6.5 $count 16 0 5 "ML" Ps"|gmt pstext $jj $rrs -N -O >> $OUT

cat 410.txt | awk '{print $1"\t"$2"\t"$4}' | gmt pstext $jj $rrs -B -P -F+f10,black+a0 -W1p -K -O >> ${OUT}
cat 660.txt | awk '{print $1"\t"$2"\t"$4}' | gmt pstext $jj $rrs -B -P -F+f10,black+a0 -W1p -O >> ${OUT}
#echo $count|awk '{print -6,$1+.5,16,0,5,"ML","'$stn'"}' | pstext $jj $rrs -N -O >> $OUT
gmt psconvert $OUT -A0.2c+pthick -Tg 
evince $OUT

