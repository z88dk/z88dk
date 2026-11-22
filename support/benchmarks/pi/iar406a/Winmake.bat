@rem pi.c

..\z80\bin\iccz80 -DSTATIC -v0 -ml -uua -q -e -K -gA -s9 -t4 -T -Llist\ -Alist\ -I"../z80/inc/" pi.c
..\z80\bin\az80 cstartup.s01
copy Lnk.pi.xcl Lnk.xcl
..\z80\bin\xlink pi -f Lnk.xcl
del cstartup.r01 pi.r01

@rem pi_ldiv.c

..\z80\bin\iccz80 -DSTATIC -v0 -ml -uua -q -e -K -gA -s9 -t4 -T -Llist\ -Alist\ -I"../z80/inc/" pi_ldiv.c
..\z80\bin\az80 cstartup.s01
copy Lnk.pi_ldiv.xcl Lnk.xcl
..\z80\bin\xlink pi_ldiv -f Lnk.xcl
del cstartup.r01 pi_ldiv.r01
