
; int isblank(int c)

XLIB isblank

LIB asm_isblank, error_znc

isblank:

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_isblank
   
   ld l,h
   ret nz
   
   inc l
   ret
