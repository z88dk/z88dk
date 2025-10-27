
; int isprint_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isprint_fastcall

EXTERN asm_isprint, error_zc

_isprint_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isprint
   
   ld l,h
   ret c
   
   inc l
   ret
