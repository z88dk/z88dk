
; int isxdigit_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isxdigit_fastcall

EXTERN asm_isxdigit, error_zc

_isxdigit_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isxdigit
   
   ld l,h
   ret c
   
   inc l
   ret
