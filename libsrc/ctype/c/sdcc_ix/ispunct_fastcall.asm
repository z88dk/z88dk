
; int ispunct_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _ispunct_fastcall

EXTERN asm_ispunct, error_zc

_ispunct_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_ispunct
   
   ld l,h
   ret c
   
   inc l
   ret
