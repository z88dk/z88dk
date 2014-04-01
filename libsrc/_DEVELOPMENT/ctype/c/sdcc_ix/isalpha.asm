
; int isalpha(int c)

XLIB isalpha

LIB asm_isalpha, error_zc

isalpha:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   jp z, error_zc

   ld a,l
   call asm_isalpha
   
   ld l,h
   ret c
   
   inc l
   ret
