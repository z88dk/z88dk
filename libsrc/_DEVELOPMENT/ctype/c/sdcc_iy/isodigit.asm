
; int isodigit(int c)

SECTION code_ctype

PUBLIC _isodigit

EXTERN asm_isodigit, error_zc

_isodigit:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isodigit
   
   ld l,h
   ret c
   
   inc l
   ret
