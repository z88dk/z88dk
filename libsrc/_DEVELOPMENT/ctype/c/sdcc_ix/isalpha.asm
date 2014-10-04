
; int isalpha(int c)

SECTION seg_code_ctype

PUBLIC _isalpha

EXTERN asm_isalpha, error_zc

_isalpha:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isalpha
   
   ld l,h
   ret c
   
   inc l
   ret
