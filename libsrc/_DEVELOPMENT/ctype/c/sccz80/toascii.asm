
; int toascii(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC toascii

toascii:

   ld h,0
   res 7,l
   
   ret
