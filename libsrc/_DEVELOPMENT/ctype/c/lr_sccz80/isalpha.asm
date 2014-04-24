
; int isalpha(int c)

XLIB isalpha

LIB asm_isalpha, error_zc

isalpha:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isalpha
   
   ld l,h
   ret c
   
   inc l
   ret
