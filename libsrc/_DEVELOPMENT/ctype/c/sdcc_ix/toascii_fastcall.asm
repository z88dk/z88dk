
; int toascii_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _toascii_fastcall

_toascii_fastcall:

   ld h,0
   res 7,l
   
   ret
