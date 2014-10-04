
; int isxdigit(int c)

SECTION seg_code_ctype

PUBLIC _isxdigit

EXTERN asm_isxdigit, error_zc

_isxdigit:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isxdigit
   
   ld l,h
   ret c
   
   inc l
   ret
