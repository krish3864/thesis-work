rm tau410.txt
rm tau660.txt
rm tau520.txt
rm number.txt
rm number1.txt
rm number2.txt
rm latlong410.txt
rm latlong660.txt
rm latlong520.txt
for file in `cat list.data| awk '{print $1}'`
do
STLA=`saclhdr -STLA $file |awk -F"eqr" '{print $1}'`
STLO=`saclhdr -STLO $file |awk -F"eqr" '{print $1}'`
EVLA=`saclhdr -EVLA $file |awk -F"eqr" '{print $1}'`
EVLO=`saclhdr -EVLO $file |awk -F"eqr" '{print $1}'`
EVDP=`saclhdr -EVDP $file |awk -F"eqr" '{print $1/1000}'`
#echo $STLA $STLO $EVLA $EVLO $EVDP 

taup_pierce -mod iasp91 -h $EVDP -ph P410s -sta $STLA $STLO -evt $EVLA $EVLO --pierce 410 --nodiscon  >>tau410.txt
taup_pierce -mod iasp91 -h $EVDP -ph P520s -sta $STLA $STLO -evt $EVLA $EVLO --pierce 520 --nodiscon  >>tau520.txt
taup_pierce -mod iasp91 -h $EVDP -ph P660s -sta $STLA $STLO -evt $EVLA $EVLO --pierce 660 --nodiscon  >>tau660.txt
done
l=`cat tau410.txt | wc -l `
for i in `seq 1 1 $l`
do
cat tau410.txt | awk -v j=$i 'NR==j {if($1 == ">") print j}' >> number.txt
done

line=`cat number.txt | wc -l | awk '{print $1}'`
for i in `seq 1 1 $line`
do
x=`cat number.txt | awk -v j=$i 'NR==j {print $1}'`
y=`cat number.txt | awk -v k=$i 'NR==k+1 {print $1}'`
sub=`echo $x $y | awk '{print $2-$1}'`
if [ $sub -eq 3 ]
	then
		cat tau410.txt | awk -v l=$x 'NR==l+2 {print $0}' >> latlong410.txt
elif [ $sub -eq 2 ] 
	then
		cat tau410.txt | awk -v a=$x 'NR==a+1 {print $0}' >> latlong410.txt
fi
done
l=`cat tau520.txt | wc -l `
for i in `seq 1 1 $l`
do
cat tau520.txt | awk -v j=$i 'NR==j {if($1 == ">") print j}' >> number1.txt
done

line=`cat number.txt | wc -l | awk '{print $1}'`
for i in `seq 1 1 $line`
do
x=`cat number.txt | awk -v j=$i 'NR==j {print $1}'`
y=`cat number.txt | awk -v k=$i 'NR==k+1 {print $1}'`
sub=`echo $x $y | awk '{print $2-$1}'`
if [ $sub -eq 3 ]
	then
		cat tau520.txt | awk -v l=$x 'NR==l+2 {print $0}' >> latlong520.txt
elif [ $sub -eq 2 ] 
	then
		cat tau520.txt | awk -v a=$x 'NR==a+1 {print $0}' >> latlong520.txt
fi
done
l=`cat tau660.txt | wc -l `
for i in `seq 1 1 $l`
do
cat tau660.txt | awk -v j=$i 'NR==j {if($1 == ">") print j}' >> number2.txt
done

line=`cat number1.txt | wc -l | awk '{print $1}'`
for i in `seq 1 1 $line`
do
x=`cat number1.txt | awk -v j=$i 'NR==j {print $1}'`
y=`cat number1.txt | awk -v k=$i 'NR==k+1 {print $1}'`
sub=`echo $x $y | awk '{print $2-$1}'`
if [ $sub -eq 3 ]
	then
		cat tau660.txt | awk -v l=$x 'NR==l+2 {print $0}' >> latlong660.txt
elif [ $sub -eq 2 ] 
	then
		cat tau660.txt | awk -v a=$x 'NR==a+1 {print $0}' >> latlong660.txt
fi
done

gmt psbasemap -R72/86/6/25 -Jm1 -Bag -K -P > taup.ps
gmt grdimage ETOPO1_Bed_g_gmt4.grd -Cmby.cpt -J -R -K -O  >>  taup.ps
gmt pscoast  -R72/86/6/25 -Jm1 -S102/178/255  -P -O -K  >> taup.ps
more AMT.txt | awk ' {print $3"\t"$2+0.35"\t"$1}'| gmt pstext -R72/86/6/25 -Jm1 -P -F+f7p,Helvetica-Bold -Bag -K -O  >> taup.ps
more AMT.txt | awk ' {print $3"\t" $2}'| gmt psxy -R72/86/6/25 -Jm1 -P -Bag -K  -O -Gpurple -St.4c >> taup.ps
more latlong410.txt | awk '{print $5"\t"$4}'| gmt psxy -R72/86/6/25 -Jm1 -P -Bag -K -O -Gred -Sc.2c >> taup.ps
more latlong520.txt | awk '{print $5"\t"$4}'| gmt psxy -R72/86/6/25 -Jm1 -P -Bag  -K -O -Ggreen  -Sc.2c >> taup.ps
more latlong660.txt | awk '{print $5"\t"$4}'| gmt psxy -R72/86/6/25 -Jm1 -P -Bag  -K -O -Gblue  -Sc.2c >> taup.ps
evince taup.ps
