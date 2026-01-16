..\z80\bin\iccz80 -DSTATIC -DPRINTF -v0 -ml -uua -q -e -K -gA -s9 -t4 -T -Llist\ -Alist\ -I"../z80/inc/" n-body.c
..\z80\bin\az80 cpm.s01
..\z80\bin\az80 cstartup.s01
..\z80\bin\xlink n-body -f Lnk.xcl
del cstartup.r01 n-body.r01 cpm.r01
