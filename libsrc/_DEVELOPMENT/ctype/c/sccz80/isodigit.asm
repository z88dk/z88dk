
; int isodigit(int c)

PUBLIC isodigit

EXTERN asm_isodigit, error_zc

isodigit:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isodigit
   
   ld l,h
   ret c
   
   inc l
   ret
