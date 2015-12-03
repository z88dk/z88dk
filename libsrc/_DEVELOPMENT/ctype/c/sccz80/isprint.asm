
; int isprint(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isprint

EXTERN asm_isprint, error_zc

isprint:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isprint
   
   ld l,h
   ret c
   
   inc l
   ret
