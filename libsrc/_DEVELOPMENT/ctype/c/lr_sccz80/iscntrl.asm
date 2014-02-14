
; int iscntrl(int c)

XLIB iscntrl

LIB asm_iscntrl, error_znc

iscntrl:

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_iscntrl
   
   ld l,h
   ret nc
   
   inc l
   ret
