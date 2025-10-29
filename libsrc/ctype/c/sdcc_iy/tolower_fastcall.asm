
; int tolower_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _tolower_fastcall

EXTERN asm_tolower

_tolower_fastcall:

   inc h
   dec h
   ret nz

   ld a,l
   call asm_tolower
   
   ld l,a
   ret
