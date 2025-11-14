..\z80\bin\iccz80 -DSTATIC -DPRINTF -v0 -ml -uua -q -e -K -gA -s9 -t4 -T -Llist\ -Alist\ -I"../z80/inc/" dhry_1.c
..\z80\bin\iccz80 -DSTATIC -DPRINTF -v0 -ml -uua -q -e -K -gA -s9 -t4 -T -Llist\ -Alist\ -I"../z80/inc/" dhry_2.c
..\z80\bin\az80 cpm.s01
..\z80\bin\az80 cstartup.s01
..\z80\bin\xlink dhry_1 dhry_2 -f Lnk.xcl
del cstartup.r01 dhry_1.r01 dhry_2.r01 cpm.r01
