
; int isdigit_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isdigit_fastcall

EXTERN asm_isdigit, error_zc

_isdigit_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isdigit
   
   ld l,h
   ret c
   
   inc l
   ret
