
; int isalnum(int c)

PUBLIC _isalnum

EXTERN asm_isalnum, error_zc

_isalnum:

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
