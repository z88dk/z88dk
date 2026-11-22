..\z80\bin\iccz80 -DSTYLE=0 -DNUM=20 -v0 -ml -uua -q -e -K -gA -s9 -t4 -T -Llist\ -Alist\ -I"../z80/inc/" sort.c
..\z80\bin\az80 cstartup.s01
..\z80\bin\xlink sort -f Lnk.xcl -l list/sr20.html -o sr20.bin
del cstartup.r01 sort.r01
..\z80\bin\iccz80 -DSTYLE=1 -DNUM=20 -v0 -ml -uua -q -e -K -gA -s9 -t4 -T -Llist\ -Alist\ -I"../z80/inc/" sort.c
..\z80\bin\az80 cstartup.s01
..\z80\bin\xlink sort -f Lnk.xcl -l list/so20.html -o so20.bin
del cstartup.r01 sort.r01
..\z80\bin\iccz80 -DSTYLE=2 -DNUM=20 -v0 -ml -uua -q -e -K -gA -s9 -t4 -T -Llist\ -Alist\ -I"../z80/inc/" sort.c
..\z80\bin\az80 cstartup.s01
..\z80\bin\xlink sort -f Lnk.xcl -l list/sv20.html -o sv20.bin
del cstartup.r01 sort.r01 cpm.r01
..\z80\bin\iccz80 -DSTYLE=3 -DNUM=20 -v0 -ml -uua -q -e -K -gA -s9 -t4 -T -Llist\ -Alist\ -I"../z80/inc/" sort.c
..\z80\bin\az80 cstartup.s01
..\z80\bin\xlink sort -f Lnk.xcl -l list/se20.html -o se20.bin
del cstartup.r01 sort.r01
..\z80\bin\iccz80 -DSTYLE=0 -DNUM=5000 -v0 -ml -uua -q -e -K -gA -s9 -t4 -T -Llist\ -Alist\ -I"../z80/inc/" sort.c
..\z80\bin\az80 cstartup.s01
..\z80\bin\xlink sort -f Lnk.xcl -l list/sr5000.html -o sr5000.bin
del cstartup.r01 sort.r01
..\z80\bin\iccz80 -DSTYLE=1 -DNUM=5000 -v0 -ml -uua -q -e -K -gA -s9 -t4 -T -Llist\ -Alist\ -I"../z80/inc/" sort.c
..\z80\bin\az80 cstartup.s01
..\z80\bin\xlink sort -f Lnk.xcl -l list/so5000.html -o so5000.bin
del cstartup.r01 sort.r01
..\z80\bin\iccz80 -DSTYLE=2 -DNUM=5000 -v0 -ml -uua -q -e -K -gA -s9 -t4 -T -Llist\ -Alist\ -I"../z80/inc/" sort.c
..\z80\bin\az80 cstartup.s01
..\z80\bin\xlink sort -f Lnk.xcl -l list/sv5000.html -o sv5000.bin
del cstartup.r01 sort.r01
..\z80\bin\iccz80 -DSTYLE=3 -DNUM=5000 -v0 -ml -uua -q -e -K -gA -s9 -t4 -T -Llist\ -Alist\ -I"../z80/inc/" sort.c
..\z80\bin\az80 cstartup.s01
..\z80\bin\xlink sort -f Lnk.xcl -l list/se5000.html -o se5000.bin
del cstartup.r01 sort.r01
