cc	----------------------------------------------------------------------------------
cc	Make table from RF ascii file (RF amplitude) and piercing points from Pierce file
cc	ASCII file HSN_2000.313.18.36.29.asc and Pierce file HSN_2000.313.18.36.29.pierce
cc	----------------------------------------------------------------------------------
cc	Important: After 70 space fortran (gfortran) will not print anything
cc	Check below. Yellow color after 70th space
c	1234567891234567891234567891234567891234567891234567891234567789123456789
c	----------------------------------------------------------------------------------
	character input*21,ascfile*25,piercefile*28,buf1*65,buf*100
	character stn*3,evt*17,refmodel*7,phase*5,tabfile*25
	dimension amp(5000)
	open(unit=12,file='inputfile',status='old')
888	read(12,'(a21)',end=999)input
c	write(*,'(a21)')input
	stn=input(1:3)
	evt=input(5:21)
	ascfile(1:21)=input
	ascfile(22:25)='.asc'
	piercefile(1:21)=input
	piercefile(22:28)='.pierce'
	tabfile(1:21)=input
	tabfile(22:25)='.tbl'
c	write(*,*)'Stn name =',stn,' evt name =',evt,' ascifile =',ascfile
c	write(*,*)'pierecfile=',piercefile,'Table file=',tabfile
c	--------------------------------------------------
c	Picking amplitude informations from RF ascii file
c	--------------------------------------------------
c	Reading first 30 lines of ascii file
	open(unit=15,file=ascfile,status='old')
	do 333 i=1,30
	read(15,20)buf1
20	format(a65)
c	write(*,*)buf1
333	continue
c	Reading amplitude informations
c	RF -5 to 120 sec and sample 20 so 125*20=2500
	read(15,*)(amp(i),i=1,2500)
c	write(*,*)(amp(i),i=1,2500)
	close(15)
c	---------------------------------------------------
c	Picking piercing points (latitude and longitude) and depth Vs Amplitude
	open(unit=16,file=piercefile,status='old')
	open(unit=17,file=tabfile,status='unknown')
c	reading first line of pierce file
c	> P at   502.14 seconds at    46.63 degrees for a     52.0 km deep source in the iaspnew model with rayParam    7.829 s/deg.	
222	read(16,22)buf
c	write(*,22)buf
22	format(a100)
	if(buf(1:4) .eq. '> P ') then
		read(buf,33)ptime,deg,depth,refmodel
c		write(*,33)ptime,deg,depth,refmodel
c	reading Ptravel time, Epicentral Distance, depth, ref model
33		format(8x,f7.2,14x,f6.2,18x,f5.1,23x,a7)
	else
		goto 222
	endif

c	Reading Ps trvel time in different depth from 150-800Km and piercing point
101	read(16,23,end=777)buf
c	write(*,23)buf
23	format(a100)
	if(buf(1:3) .eq. '> P')then
		goto 202
	else
		goto 101
	endif
202	read(buf,209)phase
	read(buf,210)ndepth,ttime
c	write(*,209)phase
c	write(*,210)ndepth,ttime
209	format(2x,a5)
210	format(3x,i3,7x,f7.2)
c	Calculating Ps-P traveltime
	difftime=ttime-ptime
c	Rfs are from -5 to 120s.and 20samples.5*20=100 (so +100)
	nsample=(difftime*20)+100
c	write(*,65)input,deg,ndepth,ttime,ptime,difftime
c65	format(a21,f7.2,i5,3f7.2)
c	---------------------------------------------------------------

c	Travel time curve pierce the same depths twice. Second piercing point is near the station so used.
c	First pierce point is avoided by reading all the depths down to 800 km
102	read(16,50)dist,tdepth,sec,alat,alon
c	write(*,50)dist,tdepth,sec,alat,alon
50	format(2x,f6.2,2x,f6.1,2x,f6.1,3x,f7.2,3x,f7.2)
	if(tdepth .le. 800.0) then
		goto 102
	else
	endif

c	Reading dist,tdepth(depthslice), sec, lat,lon (Piercing points)
c	Taking informations like piercing points and RF amplitudes for diff depths
104	read(16,60,end=777)dist,tdepth,sec,alat,alon
c	write(*,60)dist,tdepth,sec,alat,alon
60	format(2x,f6.2,2x,f6.1,2x,f6.1,3x,f7.2,3x,f7.2)

	if(tdepth .eq. ndepth)then
cc	& is used in position 6 to continuation of line in GFORTRAN. Is F77 remove &
      		write(*,66)input,deg,ndepth,ttime,ptime,difftime,dist,tdepth,
     &sec,alat,alon,phase,nsample,amp(nsample),ndepth
      		write(17,66)input,deg,ndepth,ttime,ptime,difftime,dist,tdepth,
     &sec,alat,alon,phase,nsample,amp(nsample),ndepth
66		format(a21,f7.2,i5,4f7.2,f6.1,f7.1,2f7.2,2x,a5,i6,1x,f12.8,1x,i5)
		goto 101
	else
		goto 104
	endif
		goto 104
777	close(16)
c	Pierce file information taken
c	-----------------------------------------------------
	goto 888
999	close(12)
	end
