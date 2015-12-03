
; int isspace(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isspace

EXTERN asm_isspace, error_zc

isspace:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isspace
   
   ld l,h
   ret c
   
   inc l
   ret
