
; int isxdigit(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isxdigit

EXTERN asm_isxdigit, error_zc

isxdigit:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isxdigit
   
   ld l,h
   ret c
   
   inc l
   ret
