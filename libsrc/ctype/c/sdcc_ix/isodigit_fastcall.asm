
; int isodigit(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isodigit_fastcall

EXTERN asm_isodigit, error_zc

_isodigit_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isodigit
   
   ld l,h
   ret c
   
   inc l
   ret
