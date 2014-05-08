
; int isascii(int c)

PUBLIC _isascii

EXTERN error_znc

_isascii:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   jp nz, error_znc

   bit 7,l
   
   ld l,h
   ret nz

   inc l
   ret
