..\z80\bin\iccz80 -DSTATIC -v0 -ml -uua -q -e -K -gA -s9 -t4 -T -Llist\ -Alist\ -I"../z80/inc/" binary-trees.c
..\z80\bin\az80 cstartup.s01
..\z80\bin\xlink binary-trees -f Lnk.xcl
del cstartup.r01 binary-trees
