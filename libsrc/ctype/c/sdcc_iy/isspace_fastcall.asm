
; int isspace_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isspace_fastcall

EXTERN asm_isspace, error_zc

_isspace_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isspace
   
   ld l,h
   ret c
   
   inc l
   ret
