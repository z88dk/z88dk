; 05.2005 aralbrec

PUBLIC ba_BlockCount
EXTERN BABlockCount

.ba_BlockCount
   call BABlockCount
   ld l,c
   ld h,b
   ret
