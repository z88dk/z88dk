
; int islower_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _islower_fastcall

EXTERN asm_islower, error_zc

_islower_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_islower
   
   ld l,h
   ret c
   
   inc l
   ret
