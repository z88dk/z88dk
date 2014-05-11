
; int tolower(int c)

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
