
; int isascii(int c)

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
