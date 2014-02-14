
; int isbdigit(int c)

XLIB isbdigit

LIB asm_isbdigit, error_znc

isbdigit:

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_isbdigit
   
   ld l,h
   ret nz
   
   inc l
   ret
