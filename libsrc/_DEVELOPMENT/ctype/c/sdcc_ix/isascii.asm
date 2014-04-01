
; int isascii(int c)

XLIB isascii

LIB error_znc

isascii:

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
