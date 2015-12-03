
; int tolower(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC tolower

EXTERN asm_tolower

tolower:

   inc h
   dec h
   ret nz

   ld a,l
   call asm_tolower
   
   ld l,a
   ret
