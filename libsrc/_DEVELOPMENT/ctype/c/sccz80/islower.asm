
; int islower(int c)

SECTION seg_code_ctype

PUBLIC islower

EXTERN asm_islower, error_zc

islower:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_islower
   
   ld l,h
   ret c
   
   inc l
   ret
