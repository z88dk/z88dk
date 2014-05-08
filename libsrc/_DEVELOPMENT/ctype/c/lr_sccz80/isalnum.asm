
; int isalnum(int c)

PUBLIC isalnum

EXTERN asm_isalnum, error_zc

isalnum:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isalnum
   
   ld l,h
   ret c
   
   inc l
   ret
