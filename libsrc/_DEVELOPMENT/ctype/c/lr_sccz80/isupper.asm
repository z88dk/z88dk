
; int isupper(int c)

PUBLIC isupper

EXTERN asm_isupper, error_zc

isupper:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isupper
   
   ld l,h
   ret c
   
   inc l
   ret
