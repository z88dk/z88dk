
; int toupper_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _toupper_fastcall

EXTERN asm_toupper

_toupper_fastcall:

   inc h
   dec h
   ret nz

   ld a,l
   call asm_toupper
   
   ld l,a
   ret
