
; int isprint(int c)

XLIB _isprint

LIB asm_isprint, error_zc

_isprint:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isprint
   
   ld l,h
   ret c
   
   inc l
   ret
