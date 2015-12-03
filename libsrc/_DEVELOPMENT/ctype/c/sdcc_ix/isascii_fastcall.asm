
; int isascii_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isascii_fastcall

EXTERN error_znc

_isascii_fastcall:

   inc h
   dec h
   jp nz, error_znc

   bit 7,l
   
   ld l,h
   ret nz

   inc l
   ret
