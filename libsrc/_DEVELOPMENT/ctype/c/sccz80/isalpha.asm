
; int isalpha(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isalpha

EXTERN asm_isalpha, error_zc

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
