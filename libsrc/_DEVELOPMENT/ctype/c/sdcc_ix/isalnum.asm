
; int isalnum(int c)

XLIB isalnum

LIB asm_isalnum, error_zc

isalnum:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isalnum
   
   ld l,h
   ret c
   
   inc l
   ret
