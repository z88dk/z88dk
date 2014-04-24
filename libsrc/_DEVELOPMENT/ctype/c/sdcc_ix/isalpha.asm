
; int isalpha(int c)

XLIB _isalpha

LIB asm_isalpha, error_zc

_isalpha:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isalpha
   
   ld l,h
   ret c
   
   inc l
   ret
