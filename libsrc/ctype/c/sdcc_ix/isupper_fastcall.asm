
; int isupper_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isupper_fastcall

EXTERN asm_isupper, error_zc

_isupper_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isupper
   
   ld l,h
   ret c
   
   inc l
   ret
