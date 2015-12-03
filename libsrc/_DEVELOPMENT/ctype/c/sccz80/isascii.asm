
; int isascii(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isascii

EXTERN error_znc

isascii:

   inc h
   dec h
   jp nz, error_znc

   bit 7,l
   
   ld l,h
   ret nz

   inc l
   ret
