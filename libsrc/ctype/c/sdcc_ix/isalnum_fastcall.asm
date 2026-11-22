
; int isalnum_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isalnum_fastcall

EXTERN asm_isalnum, error_zc

_isalnum_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isalnum
   
   ld l,h
   ret c
   
   inc l
   ret
