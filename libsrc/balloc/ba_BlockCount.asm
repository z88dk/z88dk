; 05.2005 aralbrec

SECTION code_clib
PUBLIC ba_BlockCount
EXTERN BABlockCount

.ba_BlockCount
   call BABlockCount
   ld l,c
   ld h,b
   ret
