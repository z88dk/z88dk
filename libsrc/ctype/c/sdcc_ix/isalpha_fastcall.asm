
; int isalpha_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isalpha_fastcall

EXTERN asm_isalpha, error_zc

_isalpha_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isalpha
   
   ld l,h
   ret c
   
   inc l
   ret
