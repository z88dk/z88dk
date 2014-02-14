
; int isdigit(int c)

XLIB isdigit

LIB asm_isdigit, error_zc

isdigit:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isdigit
   
   ld l,h
   ret c
   
   inc l
   ret
